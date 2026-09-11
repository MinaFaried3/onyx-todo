import 'package:onyx_todo/core/extension/not_nullable_extensions.dart';
import 'package:onyx_todo/core/fp/fp.dart';
import 'package:onyx_todo/core/localization/constants.dart';
import 'package:onyx_todo/core/localization/language_manager.dart';
import 'package:onyx_todo/core/network/services/token_service.dart';
import 'package:onyx_todo/core/storage/shared_preferences/shared_pref_keys.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class AppPreferences extends Equatable {
  final Box _hiveBox;
  final TokenService _tokenService;

  const AppPreferences({
    required this._hiveBox,
    required this._tokenService,
  });

  //General Methods
  Future<void> setData<T>({required String key, required T data}) async {
    switch (data) {
      case String s:
        await _hiveBox.put(key, s);
      case double d:
        await _hiveBox.put(key, d);
      case int i:
        await _hiveBox.put(key, i);
      case bool b:
        await _hiveBox.put(key, b);
      default:
        await _hiveBox.put(key, data);
    }
  }

  Future<bool> getBool(String key) async => switch (_hiveBox.get(key)) {
    bool b => b,
    _ => false,
  };

  String getString(String key) => switch (_hiveBox.get(key)) {
    String s => s,
    _ => '',
  };

  int getInt(String key) => switch (_hiveBox.get(key)) {
    int i => i,
    _ => 0,
  };

  double getDouble(String key) => switch (_hiveBox.get(key)) {
    double d => d,
    _ => 0.0,
  };

  /// Returns [Option<T>] containing the stored value if present and of type [T], or [none()].
  Option<T> getOption<T>(String key) {
    final value = _hiveBox.get(key);
    return value is T ? Option.of(value) : const Option.none();
  }

  // Language
  Future<String> getAppLanguage() async {
    final lang = _hiveBox.get(PrefKeys.lang);
    if (lang case String s when s.isNotEmpty) return s;
    return LocalizationConstants.defaultLang.getLangWithCountry();
  }

  Future<void> setAppLanguage(LanguageType? type) async => _hiveBox.put(
    PrefKeys.lang,
    type?.getLangWithCountry() ?? LanguageType.english.getLangWithCountry(),
  );

  // Check if user is logged in
  Future<String> isUserLoggedIn() async {
    final token = _hiveBox.get(PrefKeys.token);
    if (token case String s when s.isNotEmpty) return s;
    return '';
  }

  Future<String> getOpeningRoutePath() async {
    final isLoggedIn = await getBool(PrefKeys.isLoggedIn);
    final userId = getString(PrefKeys.userId);

    if (isLoggedIn && userId.isNotEmpty) {
      return '/';
    }
    return '/login';
  }

  Future<String> get token async => (await _tokenService.accessToken).orEmpty();

  // Future<void> saveMainUserData({required UserModel userModel}) async {
  //   // await saveTokensData(tokens: userModel.tokens);
  //   await setData<String>(key: PrefKeys.userId, data: userModel.id!);
  // }

  String get userId {
    return getString(PrefKeys.userId);
  }

  Future<String?> getUserData() async => (getString(PrefKeys.userId));

  @override
  List<Object> get props => [_hiveBox];
}
