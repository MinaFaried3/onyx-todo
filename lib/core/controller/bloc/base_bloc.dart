import 'package:bloc/bloc.dart';
import 'package:onyx_todo/core/controller/controller.dart';

abstract class BaseBloc<E extends BaseEvent, S extends BaseState>
    extends Bloc<E, S>
    with SafeEmitter<S>, SafeRequestHandler<S> {
  BaseBloc(super.initialState);
}
