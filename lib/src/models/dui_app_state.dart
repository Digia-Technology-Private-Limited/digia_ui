import 'package:digia_ui/src/models/variable_def.dart';

class DUIAppState {
  Map<String, VariableDef>? variables;

  DUIAppState({this.variables});

  factory DUIAppState.fromJson(Map<String, dynamic> json) {
    return DUIAppState(
        variables: const VariablesJsonConverter().fromJson(json));
  }
}
