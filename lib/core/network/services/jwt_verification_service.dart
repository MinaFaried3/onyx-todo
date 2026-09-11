import 'dart:convert';
import 'package:crypto/crypto.dart';

// ─── Callback Types ────────────────────────────────────────────────────
typedef SecretProvider = Future<String> Function(String subject);
typedef OnTokenValid = void Function(JwtPayload payload);
typedef OnTokenInvalid = void Function(JwtFailure failure);

// ─── Hardcoded Algorithm Whitelist (NEVER from token header) ──────────
enum AllowedAlgorithm { HS256, HS384, HS512 }

// ─── Config (all server-side, never trusting token claims) ────────────
class JwtConfig {
  final AllowedAlgorithm algorithm; // algorithm is YOUR decision, not token's
  final String issuer; // who issued it
  final String audience; // who it's for
  final Duration clockSkewTolerance; // forgives minor time drift
  final bool validateNotBefore; // enforce nbf claim
  final bool validateExpiry; // enforce exp claim

  const JwtConfig({
    required this.algorithm,
    required this.issuer,
    required this.audience,
    this.clockSkewTolerance = const Duration(seconds: 30),
    this.validateNotBefore = true,
    this.validateExpiry = true,
  });
}

// ─── Payload (what you trust AFTER verification) ──────────────────────
class JwtPayload {
  final String subject;
  final String issuer;
  final String audience;
  final DateTime issuedAt;
  final DateTime expiry;
  final DateTime? notBefore;
  final Map<String, dynamic> claims; // extra app-level claims

  const JwtPayload({
    required this.subject,
    required this.issuer,
    required this.audience,
    required this.issuedAt,
    required this.expiry,
    this.notBefore,
    this.claims = const {},
  });
}

// ─── Failure type (every failure is named, nothing is vague) ──────────
enum JwtFailureReason {
  algorithmMismatch, // token said "none" or RS512 — rejected
  signatureInvalid, // HMAC didn't match
  expired, // exp is in the past
  notYetValid, // nbf is in the future
  issuedInFuture, // iat is ahead of now (clock attack)
  issuerMismatch, // iss ≠ your server
  audienceMismatch, // aud ≠ your app
  missingClaim, // required field absent
  malformed, // can't even parse the token
  secretFetchError, // secret provider threw
}

class JwtFailure {
  final JwtFailureReason reason;
  final String details;

  const JwtFailure(this.reason, this.details);
}

// ─── Result wrapper ────────────────────────────────────────────────────
sealed class JwtResult {}

class JwtSuccess extends JwtResult {
  final JwtPayload payload;

  JwtSuccess(this.payload);
}

class JwtError extends JwtResult {
  final JwtFailure failure;

  JwtError(this.failure);
}

// ─── The Service ───────────────────────────────────────────────────────
class JwtVerificationService {
  final JwtConfig config;
  final SecretProvider
  secretProvider; // fetch secret by subject (supports key rotation)
  final OnTokenValid? onValid;
  final OnTokenInvalid? onInvalid;

  const JwtVerificationService({
    required this.config,
    required this.secretProvider,
    this.onValid,
    this.onInvalid,
  });

  Future<JwtResult> verify(String rawToken) async {
    try {
      // ── 1. Parse header WITHOUT trusting it ──────────────────────
      final header = _parseHeader(rawToken);
      if (header == null) {
        return _fail(JwtFailureReason.malformed, 'Cannot parse header');
      }

      // ── 2. Reject IMMEDIATELY if alg doesn't match YOUR config ───
      //       "none", "RS512", whatever — if it's not HS256 (or your
      //       chosen alg), it's dead on arrival. Token has no vote.
      final tokenAlg = header['alg']?.toString().toUpperCase();
      final expectedAlg = config.algorithm.name.toUpperCase();
      if (tokenAlg != expectedAlg) {
        return _fail(
          JwtFailureReason.algorithmMismatch,
          'Token claims alg=$tokenAlg, server requires $expectedAlg',
        );
      }

      // ── 3. Parse claims (still untrusted — sig not checked yet) ──
      final rawClaims = _parseClaims(rawToken);
      if (rawClaims == null)
        return _fail(JwtFailureReason.malformed, 'Cannot parse claims');

      final subject = rawClaims['sub']?.toString();
      if (subject == null)
        return _fail(JwtFailureReason.missingClaim, 'Missing sub');

      // ── 4. Fetch secret via callback (supports key rotation) ──────
      final String secret;
      try {
        secret = await secretProvider(subject);
      } catch (e) {
        return _fail(JwtFailureReason.secretFetchError, e.toString());
      }

      // ── 5. Verify signature (the actual cryptographic check) ──────
      final signatureValid = _verifySignature(
        rawToken,
        secret,
        config.algorithm,
      );
      if (!signatureValid)
        return _fail(JwtFailureReason.signatureInvalid, 'HMAC mismatch');

      // ── 6. Validate time claims (with clock skew tolerance) ───────
      final now = DateTime.now().toUtc();
      final skew = config.clockSkewTolerance;

      if (config.validateExpiry) {
        final exp = _extractTime(rawClaims, 'exp');
        if (exp == null)
          return _fail(JwtFailureReason.missingClaim, 'Missing exp');
        if (now.isAfter(exp.add(skew)))
          return _fail(JwtFailureReason.expired, 'Token expired at $exp');
      }

      if (config.validateNotBefore) {
        final nbf = _extractTime(rawClaims, 'nbf');
        if (nbf != null && now.isBefore(nbf.subtract(skew))) {
          return _fail(
            JwtFailureReason.notYetValid,
            'Token not valid until $nbf',
          );
        }
      }

      final iat = _extractTime(rawClaims, 'iat');
      if (iat != null && iat.isAfter(now.add(skew))) {
        return _fail(
          JwtFailureReason.issuedInFuture,
          'iat is ahead of server clock',
        );
      }

      // ── 7. Validate issuer & audience (server-side strings only) ──
      final iss = rawClaims['iss']?.toString();
      if (iss != config.issuer) {
        return _fail(
          JwtFailureReason.issuerMismatch,
          'Expected ${config.issuer}, got $iss',
        );
      }

      final aud = rawClaims['aud']?.toString();
      if (aud != config.audience) {
        return _fail(
          JwtFailureReason.audienceMismatch,
          'Expected ${config.audience}, got $aud',
        );
      }

      // ── 8. All checks passed — build trusted payload ──────────────
      final payload = JwtPayload(
        subject: subject,
        issuer: iss!,
        audience: aud!,
        issuedAt: iat ?? now,
        expiry: _extractTime(rawClaims, 'exp')!,
        notBefore: _extractTime(rawClaims, 'nbf'),
        claims: Map.from(rawClaims)
          ..removeWhere(
            (k, _) => ['sub', 'iss', 'aud', 'exp', 'nbf', 'iat'].contains(k),
          ),
      );

      onValid?.call(payload);
      return JwtSuccess(payload);
    } catch (e) {
      return _fail(JwtFailureReason.malformed, 'Unexpected: $e');
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────
  JwtError _fail(JwtFailureReason reason, String details) {
    final failure = JwtFailure(reason, details);
    onInvalid?.call(failure);
    return JwtError(failure);
  }

  Map<String, dynamic>? _parseHeader(String token) {
    final parts = token.split('.');
    if (parts.isEmpty) return null;
    return _decodeBase64UrlPart(parts[0]);
  }

  Map<String, dynamic>? _parseClaims(String token) {
    final parts = token.split('.');
    if (parts.length < 2) return null;
    return _decodeBase64UrlPart(parts[1]);
  }

  Map<String, dynamic>? _decodeBase64UrlPart(String part) {
    try {
      final normalized = base64Url.normalize(part);
      final decodedString = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decodedString) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  DateTime? _extractTime(Map claims, String key) {
    final v = claims[key];
    if (v == null) return null;
    
    final seconds = v is int ? v : int.tryParse(v.toString());
    if (seconds == null) return null;
    
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
  }

  bool _verifySignature(String token, String secret, AllowedAlgorithm alg) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      
      final headerAndPayload = '${parts[0]}.${parts[1]}';
      final signature = parts[2];
      
      final secretBytes = utf8.encode(secret);
      final messageBytes = ascii.encode(headerAndPayload);
      
      Hash hashFunc;
      switch (alg) {
        case AllowedAlgorithm.HS256:
          hashFunc = sha256;
          break;
        case AllowedAlgorithm.HS384:
          hashFunc = sha384;
          break;
        case AllowedAlgorithm.HS512:
          hashFunc = sha512;
          break;
      }
      
      final hmac = Hmac(hashFunc, secretBytes);
      final digest = hmac.convert(messageBytes);
      
      // JWT signature uses base64Url without padding '='
      final expectedSignature = base64Url.encode(digest.bytes).replaceAll('=', '');
      
      return signature == expectedSignature;
    } catch (_) {
      return false;
    }
  }
}
