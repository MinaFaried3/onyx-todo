import 'dart:convert';

import 'package:dio/dio.dart';

class RequestKeyBuilder {
  static String fromOptions(RequestOptions options) {
    final map = {
      'method': options.method.toUpperCase(),
      'url': options.uri.toString(),
      'query': _stableSortedMap(options.queryParameters),
      'data': _serializeBody(options.data),
      'headers': _filteredHeaders(options.headers),
    };

    // jsonEncode gives stable, canonical output unlike map.toString()
    return jsonEncode(map);
  }

  static dynamic _serializeBody(dynamic data) {
    if (data == null) return null;
    if (data is Map) return _stableSortedMap(Map<String, dynamic>.from(data));
    if (data is FormData) {
      // FormData is not deterministically serializable — treat each as unique
      // or serialize its fields map if you want dedup on multipart
      return data.fields.map((f) => '${f.key}=${f.value}').join('&');
    }
    return data.toString();
  }

  /// Sorts map keys so {"b":1,"a":2} and {"a":2,"b":1} produce the same key
  static Map<String, dynamic> _stableSortedMap(Map<String, dynamic> input) {
    final sorted = Map.fromEntries(
      input.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return sorted;
  }

  static Map<String, dynamic> _filteredHeaders(Map<String, dynamic> headers) {
    final copy = Map<String, dynamic>.from(headers);
    // Remove volatile / per-request headers that differ even for same logical request
    const volatileHeaders = {'timestamp', 'request-id', 'x-request-id', 'date'};
    for (final h in volatileHeaders) {
      copy.remove(h);
    }
    return _stableSortedMap(copy);
  }
}
