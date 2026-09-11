import 'package:flutter/cupertino.dart';

abstract class CacheOnSubsequentCalls {
  static final ValueNotifier<bool> locationsRequests =
      ValueNotifier<bool>(true);

  //@NOTE add every notifier to this list
  static final List<ValueNotifier<bool>> _allCacheOnSubsequentCalls = [
    locationsRequests,
  ];

  static void reset() {
    for (var request in _allCacheOnSubsequentCalls) {
      request.value = true;
    }
  }
}
