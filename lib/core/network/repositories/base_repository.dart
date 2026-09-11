import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/helper/typedefs.dart';
import 'package:onyx_todo/core/network/data_source/base_remote_data_source.dart';
import 'package:onyx_todo/core/network/data_source/local_data_source.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/core/network/error/data_source_status.dart';
import 'package:onyx_todo/core/network/error/network_error_handler.dart';
import 'package:onyx_todo/core/network/network_checker.dart';
import 'package:onyx_todo/core/network/response/base_response/base_response.dart';
import 'package:fpdart/fpdart.dart';

abstract class BaseRepository {
  BaseRemoteDataSource get remoteDataSource;

  NetworkChecker get networkChecker;

  LocalDataSource get localDataSource;

  const BaseRepository();

  FailureOr<Model> executeApiCall<Model>({
    required FutureBaseRes<Model> Function() apiCall,
    Future<void> Function(Model)? onSuccess,
    bool refreshHeaders = false,
  }) async {
    if (!(await networkChecker.isConnected)) {
      return Left(DataSourceStatus.noInternetConnection.getFailure());
    }

    await refreshDioOptionsIfNeeded(refreshHeaders);

    try {
      final response = await apiCall();

      if (response.meta.success) {
        if (onSuccess != null && response.data != null) {
          await onSuccess(response.data!);
        }
        if (response.data != null) {
          return Right(response.data!);
        } else {
          return Left(
            ServerFailure(
              code: response.meta.code,
              message: response.meta.message ?? 'No payload returned',
            ),
          );
        }
      } else {
        return Left(
          ServerFailure(
            code: response.meta.code,
            message: response.meta.message ?? 'error',
          ),
        );
      }
    } catch (error) {
      Printer.print(error.toString(), color: ConsoleColor.reset);
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  Future<void> refreshDioOptionsIfNeeded(bool refreshDioOptions) async {
    if (refreshDioOptions) {
      await remoteDataSource.dioFactory?.refreshBaseHeaders();
    }
  }

  FailureOr<BaseResponse<T>> executeBaseResponseCall<T>({
    required Future<BaseResponse<T>> Function() apiCall,
    bool refreshDioOptions = false,
  }) async {
    if (!await networkChecker.isConnected) {
      return Left(DataSourceStatus.noInternetConnection.getFailure());
    }
    await refreshDioOptionsIfNeeded(refreshDioOptions);
    try {
      final BaseResponse<T> response = await apiCall();

      if (response.meta.success) {
        return Right(response);
      } else {
        return Left(
          ServerFailure(
            code: response.meta.code,
            message: response.meta.message ?? 'error',
          ),
        );
      }
    } catch (error) {
      Printer.print(error.toString(), color: ConsoleColor.reset);
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  FailureOrPaginated<Model> executePaginatedApiCall<Model>({
    required FutureBasePagRes<Model> Function() apiCall,
    bool refreshDioOptions = false,
  }) async {
    if (!await networkChecker.isConnected) {
      return Left(DataSourceStatus.noInternetConnection.getFailure());
    }
    await refreshDioOptionsIfNeeded(refreshDioOptions);
    try {
      final response = await apiCall();

      if (response.meta.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(
          ServerFailure(
            code: response.meta.code,
            message: response.meta.message ?? 'error',
          ),
        );
      }
    } catch (error) {
      Printer.print(error.toString(), color: ConsoleColor.reset);
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  FailureOr<Model> executeMapsApiCall<Model>({
    required Future<Model> Function() apiCall,
    bool refreshDioOptions = false,
  }) async {
    if (!await networkChecker.isConnected) {
      return Left(DataSourceStatus.noInternetConnection.getFailure());
    }
    await refreshDioOptionsIfNeeded(refreshDioOptions);
    try {
      final response = await apiCall();
      return Right(response);
    } catch (error) {
      Printer.print(error.toString(), color: ConsoleColor.reset);
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Functional [TaskEither] API executor for seamless composable async pipelines.
  TaskFailureOr<Model> executeTaskApiCall<Model>({
    required FutureBaseRes<Model> Function() apiCall,
    Future<void> Function(Model)? onSuccess,
    bool refreshHeaders = false,
  }) =>
      TaskEither(() => executeApiCall(
            apiCall: apiCall,
            onSuccess: onSuccess,
            refreshHeaders: refreshHeaders,
          ));

  /// Functional [TaskEither] paginated API executor.
  TaskFailureOrPaginated<Model> executeTaskPaginatedApiCall<Model>({
    required FutureBasePagRes<Model> Function() apiCall,
    bool refreshDioOptions = false,
  }) =>
      TaskEither(() => executePaginatedApiCall(
            apiCall: apiCall,
            refreshDioOptions: refreshDioOptions,
          ));
}

