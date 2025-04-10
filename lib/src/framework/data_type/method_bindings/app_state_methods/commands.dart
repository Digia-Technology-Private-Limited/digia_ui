import '../../../../config/app_state/reactive_value.dart';

import '../base.dart';

class AppStateVariableSetCommand implements MethodCommand<ReactiveValue> {
  @override
  void run(ReactiveValue instance, Map<String, Object?> args) {
    final value = args['value'];
    if (value.runtimeType == instance.value.runtimeType) {
      instance.update(value);
    } else {
      throw Exception(
          'Value is not the same type as expected: ${instance.value.runtimeType}');
    }
  }
}
