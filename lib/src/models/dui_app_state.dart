import '../framework/utils/functional_util.dart';
import 'variable_def.dart';

class DUIAppState {
  Map<String, VariableDef>? variables;

  DUIAppState({this.variables});

  factory DUIAppState.fromJson(Map<String, dynamic> json) {
    return DUIAppState(
        variables: const VariablesJsonConverter()
            .fromJson(as$<Map<String, dynamic>>(json['variables'])));
  }
}
