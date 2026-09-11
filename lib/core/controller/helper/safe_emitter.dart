import 'package:bloc/bloc.dart';

import '../../helper/printer_manager.dart';

mixin SafeEmitter<State> on BlocBase<State> {
  @override
  void emit(State state) {
    if (isClosed) {
      Printer.print(
        "this controller is closed , can't emit $State from $this",
        color: ConsoleColor.redBg,
      );
      return;
    }

    if (this.state == state) {
      Printer.print(
        "can't emit the provided state because it is same with the current state $this",
        color: ConsoleColor.brightRed,
      );
      return;
    }

    super.emit(state);
  }
}
