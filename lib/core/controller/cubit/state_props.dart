import 'package:equatable/equatable.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';

final class StateProps extends Equatable {
  final SubState<bool> maintenanceMode;

  const StateProps({this.maintenanceMode = const SubState<bool>()});

  @override
  List<Object?> get props => [maintenanceMode];

  StateProps copyWith({SubState<bool>? maintenanceMode}) {
    return StateProps(maintenanceMode: maintenanceMode ?? this.maintenanceMode);
  }
}
