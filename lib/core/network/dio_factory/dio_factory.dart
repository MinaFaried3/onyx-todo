import 'package:alice/alice.dart';
import 'package:onyx_todo/core/config/environments/maps_config.dart';
import 'package:onyx_todo/core/config/platform/platform.dart';
import 'package:onyx_todo/core/extension/not_nullable_extensions.dart';
import 'package:onyx_todo/core/helper/constants.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/core/localization/language_manager.dart';
import 'package:onyx_todo/core/maps/network/end_points.dart';
import 'package:onyx_todo/core/network/dio_factory/api_type.dart';
import 'package:onyx_todo/core/network/dio_factory/interceptors/cancel_token_interceptor.dart';
import 'package:onyx_todo/core/network/dio_factory/interceptors/dedup_interceptor.dart';
import 'package:onyx_todo/core/network/headers_manager.dart';
import 'package:onyx_todo/core/network/services/token_service.dart';
import 'package:onyx_todo/core/storage/shared_preferences/app_preferences.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'interceptors/alice_interceptor.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/firebase_performance_interceptor.dart';

class DioFactory {
  final AppPreferences _appPreferences;
  final TokenService _tokenService;

  final String apiBaseUrl;
  final MapsConfig? mapsConfig;

  //! Controls PrettyDioLogger + Alice injection.
  final bool networkLogs;

  final Map<ApiType, Dio> _dios = {};

  DioFactory({
    required this._appPreferences,
    required this._tokenService,
    required this.apiBaseUrl,
    this.mapsConfig,
    this.networkLogs = false,
  });

  Future<Dio> getDio(ApiType apiType) async {
    if (_dios.containsKey(apiType)) return _dios[apiType]!;

    final dio = Dio();
    dio.options = await _getDioBaseOptions(apiType);
    _addInterceptors(dio, apiType);
    _dios[apiType] = dio;
    return dio;
  }

  void _addInterceptors(Dio dio, [ApiType apiType = ApiType.primary]) {
    dio.interceptors.clear(); // prevent duplicates
    if (apiType == ApiType.primary) {
      dio.interceptors.add(
        AuthInterceptor(dio: dio, tokenService: _tokenService),
      );
    }
    dio.interceptors.add(DioFirebasePerformanceInterceptor());
    dio.interceptors.add(CancelTokenInterceptor());
    dio.interceptors.add(DedupInterceptor());
    _addDevInterceptor(dio);
  }

  void _addDevInterceptor(Dio dio) {
    if (!networkLogs) return;

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        request: true,
        error: true,
        logPrint: Printer.log,
      ),
    );

    if (getIt.isRegistered<Alice>()) {
      dio.interceptors.add(AliceInterceptor(getIt<Alice>()));
    }
  }

  Future<void> refreshBaseHeaders([ApiType apiType = ApiType.primary]) async {
    if (_dios.containsKey(apiType)) {
      _dios[apiType]!.options.headers = await _getBaseHeaders(apiType);
    }
  }

  Future<BaseOptions> _getDioBaseOptions(ApiType apiType) async {
    final headers = await _getBaseHeaders(apiType);

    final baseOptions = BaseOptions(
      baseUrl: switch (apiType) {
        ApiType.primary => apiBaseUrl,
        ApiType.maps => 'https://maps.googleapis.com/',
      },
      headers: headers,
      sendTimeout: DurationManager.apiTimeOut,
      receiveTimeout: DurationManager.apiTimeOut,
      receiveDataWhenStatusError: true,
      responseType: switch (apiType) {
        ApiType.primary => ResponseType.json,
        ApiType.maps => ResponseType.json,
      },
    );

    if (CurrentPlatform.isWeb) {
      //? attach cookies with requests
      //todo try without it at web
      // baseOptions.extra['withCredentials'] = false;
    }

    return baseOptions;
  }

  Future<Map<String, String>> _getBaseHeaders(ApiType apiType) async {
    final [langResult, tokenResult] = await Future.wait([
      _appPreferences.getAppLanguage(),
      _tokenService.accessToken,
    ]);

    Printer.print(
      "DioFactory._getBaseHeaders: langResult = $langResult, tokenResult = $tokenResult",
    );

    final String langCode = (langResult as String)
        .split(LanguageType.langSeparator)
        .first;
    final String token = tokenResult.orEmpty();

    return switch (apiType) {
      ApiType.primary => await HeadersManager.baseHeaders(langCode, token),
      ApiType.maps => MapsHeader.mapsBaseHeaders(
        langCode,
        mapsConfig?.placesApiKey ?? '',
      ),
    };
  }
}
