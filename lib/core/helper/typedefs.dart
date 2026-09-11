import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/core/network/response/base_pagination_response/base_pagination_response.dart';
import 'package:onyx_todo/core/network/response/base_pagination_response/paginated_list.dart';
import 'package:onyx_todo/core/network/response/base_response/base_response.dart';
import 'package:fpdart/fpdart.dart';

typedef PlatformCallback<T> = T Function();
typedef Json = Map<String, dynamic>;

/// Functional Error Handling Typedefs (fpdart Either & TaskEither)
typedef FailureOr<X> = Future<Either<Failure, X>>;
typedef FailureOrList<X> = FailureOr<List<X>>;
typedef FailureOrPaginated<X> = FailureOr<PaginatedList<X>>;

typedef TaskFailureOr<X> = TaskEither<Failure, X>;
typedef TaskFailureOrList<X> = TaskFailureOr<List<X>>;
typedef TaskFailureOrPaginated<X> = TaskFailureOr<PaginatedList<X>>;

typedef FutureBaseRes<X> = Future<BaseResponse<X>>;
typedef FutureBasePagRes<X> = Future<BasePaginationResponse<X>>;

