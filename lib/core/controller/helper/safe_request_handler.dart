import 'package:bloc/bloc.dart';
import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:fpdart/fpdart.dart';

mixin SafeRequestHandler<State extends BaseState> on BlocBase<State> {
  /// Handles an [Either] result and safely emits the corresponding state.
  void handleResult<T>(
    Either<Failure, T> result, {
    required State Function(T data) onSuccess,
    required State Function(Failure failure) onFailure,
  }) {
    if (isClosed) return;
    result.match(
      (failure) {
        if (isClosed || failure.isCancelled) return;
        final nextState = onFailure(failure);
        emit(nextState.copyWith(failure: () => failure) as State);
      },
      (data) {
        if (isClosed) return;
        final nextState = onSuccess(data);
        emit(nextState.copyWith(failure: () => null) as State);
      },
    );
  }

  /// Handles a [TaskEither] computation by running it and emitting the resulting state.
  Future<void> handleTask<T>(
    TaskEither<Failure, T> task, {
    required State Function(T data) onSuccess,
    required State Function(Failure failure) onFailure,
  }) async {
    if (isClosed) return;
    final result = await task.run();
    handleResult(result, onSuccess: onSuccess, onFailure: onFailure);
  }
}

