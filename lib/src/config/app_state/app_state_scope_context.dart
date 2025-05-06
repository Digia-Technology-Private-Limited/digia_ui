import '../../framework/expr/default_scope_context.dart';
import 'reactive_value.dart';

class AppStateScopeContext extends DefaultScopeContext {
  final Map<String, ReactiveValue<Object?>> _values;

  AppStateScopeContext({
    required Map<String, ReactiveValue> values,
    super.variables = const {},
    super.enclosing,
  })  : _values = values,
        super(name: 'appState');

  @override
  ({bool found, Object? value}) getValue(String key) {
    if (key == 'appState') {
      return (
        found: true,
        value: {
          ..._values.map((k, v) => MapEntry(k, v.value)),
          ..._values.map((k, v) => MapEntry(v.streamName, v.controller))
        }
      );
    }

    if (_values.containsKey(key)) {
      return (found: true, value: _values[key]!.value);
    }

    if (_values.values.map((e) => e.streamName).contains(key)) {
      return (found: true, value: _values[key]!.controller);
    }

    return super.getValue(key);
  }
}
