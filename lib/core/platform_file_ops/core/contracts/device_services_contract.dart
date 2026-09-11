import '../models/visual_viewport_info.dart';

abstract class DeviceServicesContract {
  const DeviceServicesContract();

  String get locationOrigin;

  String get locationHref;

  double get devicePixelRatio;

  int get innerWidth;

  int get innerHeight;

  int get outerWidth;

  int get outerHeight;

  int get screenWidth;

  int get screenHeight;

  String get userAgent;

  VisualViewportInfo? get visualViewport;

  String? readLocalStorage(String key);

  void writeLocalStorage(String key, String value);

  void removeLocalStorage(String key);

  void clearLocalStorage();

  String? readSessionStorage(String key);

  void writeSessionStorage(String key, String value);

  void pushState(String url, {String title = ""});

  void disableBrowserBackButton();

  void openUrl(String url, {String target = '_blank', String? features});

  Future<List<int>> fetchBytes(String url);

  void triggerDownload({
    required String url,
    required String attributeName,
    required String attributeValue,
  });

  int measureCssPixelsPerInch();
}
