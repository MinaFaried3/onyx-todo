import 'package:onyx_todo/core/localization/core_strings.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';

class ApiInternalStatus {
  static const int success = 200;
  static const int failure = 409;
}

// Enum for handling HTTP status codes and local failure codes
enum DataSourceStatus {
  success(200, CoreStrings.success),
  noContent(201, CoreStrings.created),
  badRequest(400, CoreStrings.badRequestError),
  unauthorized(401, CoreStrings.unauthorizedError),
  paymentRequired(402, CoreStrings.paymentRequiredError),
  forbidden(403, CoreStrings.forbiddenError),
  notFound(404, CoreStrings.notFoundError),
  sendTimeout(408, CoreStrings.timeoutError),
  invalidData(422, CoreStrings.invalidDataError),
  internalServerError(500, CoreStrings.internalServerError),
  notImplemented(501, CoreStrings.notImplementedError),
  badResponse(444, CoreStrings.defaultError),
  badCertificate(495, CoreStrings.defaultError),

  // Local status codes
  connectTimeout(FailureCode.connectTimeout, CoreStrings.timeoutError),
  cancel(FailureCode.cancel, CoreStrings.defaultError),
  receiveTimeout(FailureCode.receiveTimeout, CoreStrings.timeoutError),
  cacheError(FailureCode.cacheError, CoreStrings.cacheError),
  noInternetConnection(FailureCode.noInternetConnection, CoreStrings.noInternetError),
  defaultState(FailureCode.defaultState, CoreStrings.defaultError);

  final int code;
  final String message;

  const DataSourceStatus(this.code, this.message);
}

extension DataSourceStatusExtension on DataSourceStatus {
  bool get isSuccess =>
      this == DataSourceStatus.success || this == DataSourceStatus.noContent;

  bool get isClientError =>
      this == DataSourceStatus.badRequest ||
      this == DataSourceStatus.unauthorized ||
      this == DataSourceStatus.paymentRequired ||
      this == DataSourceStatus.forbidden ||
      this == DataSourceStatus.notFound ||
      this == DataSourceStatus.invalidData;

  bool get isServerError =>
      this == DataSourceStatus.internalServerError ||
      this == DataSourceStatus.notImplemented ||
      this == DataSourceStatus.badResponse ||
      this == DataSourceStatus.badCertificate;

  bool get isTimeout =>
      this == DataSourceStatus.sendTimeout ||
      this == DataSourceStatus.connectTimeout ||
      this == DataSourceStatus.receiveTimeout;

  bool get isNetworkError =>
      this == DataSourceStatus.noInternetConnection ||
      this == DataSourceStatus.cacheError;

  bool isErrorCode(int statusCode) => code == statusCode;

  bool get isNotFound => this == DataSourceStatus.notFound;
}

extension DataSourceExtension on DataSourceStatus {
  Failure getFailure() {
    if (this == DataSourceStatus.badCertificate) {
      return UnsecureConnectionFailure(code: code, message: message);
    }

    if (isNetworkError) {
      return NoInternetConnectionFailure(code: code, message: message);
    }

    return UnKnownFailure(code: code, message: message);
  }
}
