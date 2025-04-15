import '../expr/default_scope_context.dart';
import 'state_context.dart';

class StateScopeContext extends DefaultScopeContext {
  final StateContext _stateContext;

  StateScopeContext({
    required StateContext stateContext,
    super.variables = const {},
    super.enclosing,
  })  : _stateContext = stateContext,
        super(
          name: stateContext.namespace ?? '',
        );

  @override
  ({bool found, Object? value}) getValue(String key) {
    if (key == 'state' || key == name) {
      return (
        found: true,
        // value: adaptValue(_stateContext.stateVariables),
        value: _stateContext.stateVariables,
      );
    }

    if (_stateContext.hasKey(key)) {
      // return (found: true, value: adaptValue(_stateContext.getValue(key)));
      return (found: true, value: _stateContext.getValue(key));
    }

    return super.getValue(key);
  }
}
