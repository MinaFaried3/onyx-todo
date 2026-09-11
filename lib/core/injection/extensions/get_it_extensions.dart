import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';

extension GetItX on GetIt {
  /// Registers a factory only if a type [T] is not already registered under [instanceName].
  void factoryOnce<T extends Object>(
    T Function() factory, {
    String? instanceName,
  }) {
    if (!isRegistered<T>(instanceName: instanceName)) {
      registerFactory<T>(factory, instanceName: instanceName);
    }
  }

  /// Registers a lazy singleton only if a type [T] is not already registered under [instanceName].
  void lazySingletonOnce<T extends Object>(
    T Function() factory, {
    String? instanceName,
  }) {
    if (!isRegistered<T>(instanceName: instanceName)) {
      registerLazySingleton<T>(factory, instanceName: instanceName);
    }
  }

  /// Closes and unregisters a bloc/cubit of type [T] if it exists in the container.
  void disposeBloc<T extends BlocBase>() {
    if (isRegistered<T>()) {
      this<T>().close();
      unregister<T>();
      if (!isRegistered<T>()) {
        Printer.printHint('$T is unregistered');
      }
    }
  }

  /// Registers a factory with up to two parameters only if a type [T] is not already registered.
  void factoryParamOnce<T extends Object, P1, P2>(
    T Function(P1 param1, P2 param2) factory, {
    String? instanceName,
  }) {
    if (!isRegistered<T>(instanceName: instanceName)) {
      registerFactoryParam<T, P1, P2>(factory, instanceName: instanceName);
    }
  }

  /// Registers a Data Source, Repository, and Bloc/Cubit for a specific module.
  void registerModule<
    Ds extends Object,
    Ls extends Object,
    Repo extends Object,
    Cbt extends Object
  >({
    Ds Function()? remoteDs,
    Ls Function()? localDs,
    Repo Function()? repo,
    Cbt Function()? cubit,
  }) {
    if (remoteDs != null) factoryOnce<Ds>(remoteDs);
    if (localDs != null) factoryOnce<Ls>(localDs);
    if (repo != null) factoryOnce<Repo>(repo);
    if (cubit != null) factoryOnce<Cbt>(cubit);
  }
}
