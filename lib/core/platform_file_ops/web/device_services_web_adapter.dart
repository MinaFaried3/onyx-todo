import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import '../core/contracts/device_services_contract.dart';
import '../core/models/visual_viewport_info.dart';

/// Browser implementation of [DeviceServicesContract] (DOM, storage, fetch).
final class DeviceServicesWebAdapter implements DeviceServicesContract {
  DeviceServicesWebAdapter();

  web.EventListener? _popStateHandler;

  @override
  String get locationOrigin => web.window.location.origin;

  @override
  String get locationHref => web.window.location.href;

  @override
  double get devicePixelRatio => web.window.devicePixelRatio;

  @override
  int get innerWidth => web.window.innerWidth;

  @override
  int get innerHeight => web.window.innerHeight;

  @override
  int get outerWidth => web.window.outerWidth;

  @override
  int get outerHeight => web.window.outerHeight;

  @override
  int get screenWidth => web.window.screen.width;

  @override
  int get screenHeight => web.window.screen.height;

  @override
  String get userAgent => web.window.navigator.userAgent;

  @override
  VisualViewportInfo? get visualViewport {
    final vv = web.window.visualViewport;
    if (vv == null) {
      return null;
    }
    return VisualViewportInfo(
      width: vv.width,
      height: vv.height,
      scale: vv.scale,
    );
  }

  @override
  String? readLocalStorage(String key) => web.window.localStorage.getItem(key);

  @override
  void writeLocalStorage(String key, String value) {
    web.window.localStorage.setItem(key, value);
  }

  @override
  void removeLocalStorage(String key) {
    web.window.localStorage.removeItem(key);
  }

  @override
  void clearLocalStorage() {
    web.window.localStorage.clear();
  }

  @override
  String? readSessionStorage(String key) =>
      web.window.sessionStorage.getItem(key);

  @override
  void writeSessionStorage(String key, String value) {
    web.window.sessionStorage.setItem(key, value);
  }

  @override
  void pushState(String url, {String title = ""}) {
    web.window.history.pushState(null, title, url);
  }

  @override
  void disableBrowserBackButton() {
    pushState(locationHref, title: 'disable back');
    _popStateHandler ??= ((web.Event _) {
      pushState(locationHref, title: 'disable back');
    }).toJS;
    web.window.addEventListener('popstate', _popStateHandler!);
  }

  @override
  void openUrl(String url, {String target = '_blank', String? features}) {
    web.window.open(url, target, features ?? "");
  }

  @override
  Future<List<int>> fetchBytes(String url) async {
    final response = await web.window.fetch(url.toJS).toDart;
    final buffer = await response.arrayBuffer().toDart;
    final byteBuffer = buffer.toDart;
    return Uint8List.view(byteBuffer);
  }

  @override
  void triggerDownload({
    required String url,
    required String attributeName,
    required String attributeValue,
  }) {
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..setAttribute(attributeName, attributeValue)
      ..click();
    anchor.remove();
  }

  @override
  int measureCssPixelsPerInch() {
    final div = web.HTMLDivElement()
      ..style.position = 'absolute'
      ..style.left = '-9999px'
      ..style.width = '1in'
      ..style.height = '1in'
      ..style.visibility = 'hidden'
      ..style.padding = '0'
      ..style.margin = '0'
      ..style.border = '0';
    web.document.body?.append(div);
    final measured = div.offsetWidth;
    div.remove();
    return measured <= 0 ? 96 : measured;
  }
}
