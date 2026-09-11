/// نوع الـ Dio client المستخدم في الطلب
enum ApiType { primary, maps }

extension ApiTypeExtension on ApiType {
  String get description => switch (this) {
    ApiType.primary => 'Primary API for main application data',
    ApiType.maps    => 'Google Maps API for location-based services',
  };

  bool get isPrimary => this == ApiType.primary;

  bool get isMaps => this == ApiType.maps;
}
