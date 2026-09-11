import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/navigation/overlay/overlay_manager.dart';
import 'package:go_router/go_router.dart';


abstract interface class NavigationService {
  String? get currentRouteName;
  set currentRouteName(String? value);

  void go(String location, {Object? extra});

  Future<T?> push<T>(String location, {Object? extra});

  void pop<T>([T? result]);

  void replace(String location, {Object? extra});

  bool canPop();

  void clearAndGo(String location);

  void popUntil(String location);

  void showLoading();

  void hideLoading();

  void showSnackBar(String message, {SnackBarType type});
}

class NavigationServiceImpl implements NavigationService {
  final GoRouter _router;
  final OverlayManager _overlay;
  String? _currentRouteName;

  NavigationServiceImpl({
    required this._router,
    required this._overlay,
  });

  @override
  String? get currentRouteName => _currentRouteName;

  @override
  set currentRouteName(String? value) {
    _currentRouteName = value;
  }

  bool _isValidLocation(String location) => location.startsWith('/');

  @override
  void go(String location, {Object? extra}) {
    if (!_isValidLocation(location)) {
      _log('go blocked: invalid location "$location"');
      return;
    }
    _log('go -> $location');
    _router.go(location, extra: extra);
  }

  @override
  Future<T?> push<T>(String location, {Object? extra}) {
    if (!_isValidLocation(location)) {
      _log('push blocked: invalid location "$location"');
      return Future.value(null);
    }
    _log('push -> $location');
    return _router.push<T>(location, extra: extra);
  }

  @override
  void pop<T>([T? result]) {
    _log('pop');
    if (_router.canPop()) {
      _router.pop(result);
    }
  }

  @override
  void replace(String location, {Object? extra}) {
    if (!_isValidLocation(location)) {
      _log('replace blocked: invalid location "$location"');
      return;
    }
    _log('replace -> $location');
    _router.replace(location, extra: extra);
  }

  @override
  bool canPop() => _router.canPop();

  @override
  void clearAndGo(String location) {
    _log('clearAndGo -> $location');
    go(location);
  }

  @override
  void popUntil(String location) {
    _log('popUntil -> $location');
    go(location);
  }

  @override
  void showLoading() => _overlay.showLoading();

  @override
  void hideLoading() => _overlay.hideLoading();

  @override
  void showSnackBar(String message, {SnackBarType type = SnackBarType.info}) {
    _overlay.showSnackBar(message, type: type);
  }

  void _log(String msg) => Printer.printHint('[NavigationService] $msg');
}
