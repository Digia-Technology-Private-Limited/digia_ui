import 'dart:convert';

import '../render_payload.dart';
import '../state/state_context_provider.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';
import 'data_type.dart';
import 'data_type_creator.dart';
import 'variable.dart';

class StateVariable {
  String stateContextName;
  String stateName;
  StateVariable({
    required this.stateContextName,
    required this.stateName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stateContextName': stateContextName,
      'stateName': stateName,
    };
  }

  static StateVariable? fromJson(Object? map) {
    if (map == null || map is! JsonLike) return null;

    if (map.containsKey('stateName')) {
      return StateVariable(
        stateContextName: (map['stateContextName'] as String?) ?? '',
        stateName: (map['stateName'] as String?) ?? '',
      );
    }
    return null;
  }

  String toJson() => json.encode(toMap());
}

class EitherRefOrValue {
  StateVariable? stateVariable;
  Map<String, Object?>? value;
  EitherRefOrValue({
    this.stateVariable,
    this.value,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stateVariable': stateVariable?.toMap(),
      'value': value,
    };
  }

  factory EitherRefOrValue.fromJson(Object? map) {
    if (map is! JsonLike) return EitherRefOrValue();
    return EitherRefOrValue(
      stateVariable: StateVariable.fromJson(map),
      value: as$<Map<String, Object?>>(map['value']),
    );
  }

  String toJson() => json.encode(toMap());
}

class DataTypeFetch {
  static T? dataType<T>(
      EitherRefOrValue value, RenderPayload payload, DataType dataEnum) {
    if (value.stateVariable != null) {
      final context = StateContextProvider.findStateByName(
          payload.buildContext, value.stateVariable!.stateContextName);
      final dataType = context?.getValue(value.stateVariable!.stateName) as T?;
      return dataType;
    } else if (value.value != null) {
      return DataTypeCreator.create(
          Variable(name: '', type: dataEnum, defaultValue: value.value),
          scopeContext: payload.scopeContext) as T?;
    }
    return null;
  }
}
