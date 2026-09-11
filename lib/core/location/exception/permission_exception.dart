base class LocationPermissionException implements Exception {}

final class LocationPermissionDeniedForever
    extends LocationPermissionException {}

final class LocationPermissionDenied extends LocationPermissionException {}
