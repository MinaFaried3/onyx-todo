import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:onyx_todo/core/config/environments/core_config.dart';
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/core/injection/instance_name.dart';
import 'package:onyx_todo/core/network/api_service/base_api_service.dart';
import 'package:onyx_todo/core/network/data_source/local_data_source.dart';
import 'package:onyx_todo/core/network/dio_factory/api_type.dart';
import 'package:onyx_todo/core/network/dio_factory/dio_factory.dart';
import 'package:onyx_todo/core/network/network_checker.dart';
import 'package:onyx_todo/core/network/realtime/realtime.dart';

import 'package:onyx_todo/core/network/services/cancel_request_service.dart';
import 'package:onyx_todo/core/network/services/token_service.dart';
import 'package:onyx_todo/core/storage/shared_preferences/app_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract final class NetworkModule {
  static Future<void> init({required CoreConfig configuration}) async {
    getIt.lazySingletonOnce<CancelRequestService>(
      () => CancelRequestService(),
    );

    getIt.lazySingletonOnce<NetworkChecker>(
      () => NetworkCheckerImpl(connectionChecker: Connectivity()),
    );

    // Alice — registered only in debug mode
    if (kDebugMode) {
      getIt.lazySingletonOnce<Alice>(
        () => Alice(
          configuration: AliceConfiguration(
            showNotification: true,
            showInspectorOnShake: true,
            showShareButton: true,
            navigatorKey: getIt<GlobalKey<NavigatorState>>(),
          ),
        ),
      );
    }

    // DioFactory
    getIt.lazySingletonOnce<DioFactory>(
      () => DioFactory(
        appPreferences: getIt<AppPreferences>(),
        tokenService: getIt<TokenService>(),
        apiBaseUrl: configuration.apiBaseUrl,
        mapsConfig: configuration.maps,
        networkLogs: kDebugMode,
      ),
    );

    // Primary Dio
    final Dio primaryDio = await getIt<DioFactory>().getDio(ApiType.primary);
    getIt.lazySingletonOnce<Dio>(() => primaryDio);

    // API Service
    getIt.lazySingletonOnce<ApiService>(
      () => DioApiService(getIt<Dio>()),
    );

    // Maps Dio — فقط عند وجود MapsConfig

    if (configuration.hasMaps) {
      final Dio mapsDio = await getIt<DioFactory>().getDio(ApiType.maps);
      getIt.lazySingletonOnce<Dio>(
        () => mapsDio,
        instanceName: InstanceName.mapsDio,
      );
    }

    // Local data source
    getIt.lazySingletonOnce<LocalDataSource>(() => LocalDataSourceImpl());

    // Real-Time Clients (WebSocket & SSE)
    getIt.lazySingletonOnce<WebSocketClient>(
      () => WebSocketChannelClient(),
    );
    getIt.lazySingletonOnce<SseClient>(
      () => EventFluxSseClient(),
    );
  }
}

