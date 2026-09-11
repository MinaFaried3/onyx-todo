// core/utils/validator/sql_injection_guard.dart

class SqlInjectionGuard {
  const SqlInjectionGuard._();

  // ── SQL keyword patterns ─────────────────────────────────────────────────
  static const List<String> _keywords = [
    'select',
    'insert',
    'update',
    'delete',
    'drop',
    'create',
    'alter',
    'truncate',
    'exec',
    'execute',
    'union',
    'where',
    'from',
    'having',
    'group by',
    'order by',
    'join',
    'cast',
    'convert',
    'declare',
    'xp_',
    'sp_',
    'sleep',
    'benchmark',
    'load_file',
    'outfile',
    'dumpfile',
  ];

  // ── Punctuation / operator patterns ─────────────────────────────────────
  static const List<String> _operators = [
    '--', '/*', '*/', '@@', '||',
    '0x', // hex encoding
  ];

  // ── Regex-based patterns (tautologies, comment injections, etc.) ─────────
  static final List<RegExp> _patterns = [
    RegExp(r"'\s*or\s*'?\d", caseSensitive: false), // ' OR '1
    RegExp(r"'\s*or\s+\d+\s*=\s*\d+", caseSensitive: false), // ' OR 1=1
    RegExp(r"'\s*and\s+\d+\s*=\s*\d+", caseSensitive: false), // ' AND 1=1
    RegExp(r"'\s*;", caseSensitive: false), // '; next stmt
    RegExp(r"char\s*\(", caseSensitive: false), // CHAR() encoding
    RegExp(r"ascii\s*\(", caseSensitive: false), // ASCII() encoding
    RegExp(r"substring\s*\(", caseSensitive: false), // data extraction
    RegExp(r"information_schema", caseSensitive: false), // schema sniffing
    RegExp(r"waitfor\s+delay", caseSensitive: false), // time-based SQLi
    RegExp(r"into\s+(outfile|dumpfile)", caseSensitive: false), // file writes
    RegExp(r"union\s+(all\s+)?select", caseSensitive: false), // UNION SELECT
  ];

  /// Returns `true` when the input is safe (no SQL injection detected).
  /// Returns `false` when a threat is found.
  static bool isSafe(String text) {
    if (text.isEmpty) return true;

    final lower = text.toLowerCase().trim();

    // 1. Bare single-quote check — the root of most SQL injection
    if (_containsUnpairedQuote(lower)) return false;

    // 2. Dangerous punctuation / operators
    for (final op in _operators) {
      if (lower.contains(op)) return false;
    }

    // 3. Isolated SQL keywords (must be a whole word, not a substring)
    for (final kw in _keywords) {
      if (_containsKeyword(lower, kw)) return false;
    }

    // 4. Compound regex patterns (tautologies, encodings, advanced payloads)
    for (final pattern in _patterns) {
      if (pattern.hasMatch(lower)) return false;
    }

    return true;
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  /// Detects an unbalanced/bare single quote.
  /// Allows legitimate apostrophes in names like "O'Brien" only when
  /// surrounded by word characters on both sides (possessive/contraction).
  static bool _containsUnpairedQuote(String text) {
    final apostropheInWord = RegExp(r"\w'\w"); // e.g. O'Brien, don't
    final cleaned = text.replaceAll(apostropheInWord, '');
    return cleaned.contains("'");
  }

  /// Whole-word keyword match — prevents false positives on substrings.
  /// e.g. "selection" should NOT trigger on "select".
  static bool _containsKeyword(String text, String keyword) {
    // Keywords with spaces (e.g. "group by") need a different check
    if (keyword.contains(' ')) {
      // Collapse multiple spaces and check presence
      final normalized = text.replaceAll(RegExp(r'\s+'), ' ');
      return normalized.contains(keyword);
    }
    // Single-word keyword: must be bounded by non-word characters
    final pattern = RegExp(
      r'(^|[^a-z0-9_])' + RegExp.escape(keyword) + r'([^a-z0-9_]|$)',
      caseSensitive: false,
    );
    return pattern.hasMatch(text);
  }
}
