import 'package:shared_preferences/shared_preferences.dart';

import '../../framework/utils/types.dart';
import 'global_state.dart';
import 'persisted_reactive_value.dart';
import 'reactive_value.dart';

abstract class ReactiveValueFactory {
  ReactiveValue create(StateDescriptor descriptor, SharedPreferences prefs);
}

class DefaultReactiveValueFactory implements ReactiveValueFactory {
  @override
  ReactiveValue create(StateDescriptor descriptor, SharedPreferences prefs) {
    switch (descriptor.description) {
      case 'number':
        return _createTyped<num>(descriptor, prefs);
      case 'string':
        return _createTyped<String>(descriptor, prefs);
      case 'bool':
        return _createTyped<bool>(descriptor, prefs);
      case 'json':
        return _createTyped<JsonLike>(descriptor, prefs);
      case 'list':
        return _createTyped<List>(descriptor, prefs);
      default:
        throw Exception('Unsupported type for key: ${descriptor.key}');
    }
  }

  ReactiveValue<T> _createTyped<T>(
      StateDescriptor descriptor, SharedPreferences prefs) {
    final typedDescriptor = descriptor as StateDescriptor<T>;

    if (typedDescriptor.shouldPersist) {
      return PersistedReactiveValue<T>(
          prefs: prefs,
          key: typedDescriptor.key,
          initialValue: typedDescriptor.initialValue,
          fromString: typedDescriptor.deserialize,
          toString: typedDescriptor.serialize,
          streamName: typedDescriptor.streamName);
    } else {
      return ReactiveValue<T>(
          typedDescriptor.initialValue, typedDescriptor.streamName);
    }
  }
}
