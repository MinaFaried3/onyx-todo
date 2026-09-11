import 'package:bloc/bloc.dart';
import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/controller/helper/safe_emitter.dart';
import 'package:onyx_todo/core/controller/helper/safe_request_handler.dart';

abstract class BaseCubit<T extends BaseState> extends Cubit<T>
    with SafeEmitter<T>, SafeRequestHandler<T> {
  BaseCubit(super.initialState);
}
