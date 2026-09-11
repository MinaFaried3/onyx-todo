import 'package:dio/dio.dart';
import 'package:onyx_todo/core/extension/not_nullable_extensions.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/localization/core_strings.dart';
import 'package:onyx_todo/core/network/error/app_error.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/core/network/error/data_source_status.dart';
import 'package:onyx_todo/core/network/response/base_response/base_response.dart';
class ErrorHandler implements Exception {
  late final Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = handleError(error);
    } else {
      failure = DataSourceStatus.defaultState.getFailure();
    }
  }
}

Failure handleError(DioException error) => switch (error.type) {
  DioExceptionType.connectionTimeout => DataSourceStatus.connectTimeout.getFailure(),
  DioExceptionType.sendTimeout => DataSourceStatus.sendTimeout.getFailure(),
  DioExceptionType.receiveTimeout => DataSourceStatus.receiveTimeout.getFailure(),
  DioExceptionType.cancel => DataSourceStatus.cancel.getFailure(),
  DioExceptionType.unknown => DataSourceStatus.defaultState.getFailure(),
  DioExceptionType.badCertificate => DataSourceStatus.badCertificate.getFailure(),
  DioExceptionType.badResponse => handleBadResponseFailure(error),
  DioExceptionType.connectionError => DataSourceStatus.internalServerError.getFailure(),
};

Failure handleBadResponseFailure(DioException error) {
  final int? statusCode = error.response?.statusCode;

  try {
    final rawData = error.response?.data;
    BaseResponse<dynamic>? baseResponse;
    if (rawData is Map<String, dynamic>) {
      baseResponse = BaseResponse<dynamic>.fromJson(rawData, (json) => json);
    }

    final AppErrors appErrors = AppErrors(errors: baseResponse?.error?.errors ?? {});

    final String message = baseResponse?.meta.message ?? CoreStrings.defaultError;

    if (statusCode == null) return DataSourceStatus.badResponse.getFailure();

    return switch (statusCode) {
      501 => NotImplementedFailure(code: statusCode, message: message, appErrors: appErrors),
      500 => InternalServerErrorFailure(code: statusCode, message: message, appErrors: appErrors),
      400 => BadRequestFailure(code: statusCode, message: message, appErrors: appErrors),
      401 => UnauthorizedFailure(code: statusCode, message: message, appErrors: appErrors),
      402 => PaymentRequiredFailure(code: statusCode, message: message, appErrors: appErrors),
      403 => ForbiddenFailure(code: statusCode, message: message, appErrors: appErrors),
      404 => NotFoundFailure(code: statusCode, message: message, appErrors: appErrors),
      422 => UnprocessableEntityFailure(code: statusCode, message: message, appErrors: appErrors),
      _   => UnKnownFailure(code: statusCode, message: CoreStrings.defaultError, appErrors: appErrors),
    };
  } catch (e) {
    Printer.print(
      "error from Server ,,,,,,, $statusCode",
      color: ConsoleColor.redBg,
    );
    return InternalServerErrorFailure(
      code: statusCode.orZero(),
      message: error.response?.statusMessage ?? '',
      appErrors: AppErrors(errors: {}),
    );
  }
}
