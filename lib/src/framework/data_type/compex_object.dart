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
  String? type;
  EitherRefOrValue({
    this.stateVariable,
    this.value,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stateVariable': stateVariable?.toMap(),
      'value': value,
      'type': type,
    };
  }

  factory EitherRefOrValue.fromJson(Object? map) {
    if (map is! JsonLike) return EitherRefOrValue();
    return EitherRefOrValue(
        stateVariable: StateVariable.fromJson(map),
        value: as$<Map<String, Object?>>(map['value']),
        type: as$<String>(map['type']));
  }

  String toJson() => json.encode(toMap());
}

// class DataTypeFetch {
//   static T? dataType<T>(EitherRefOrValue value, RenderPayload payload) {
//     T? dataType;
//     if (value.stateVariable != null) {
//       final context = StateContextProvider.findStateByName(
//           payload.buildContext, value.stateVariable!.stateContextName);
//       dataType = context?.getValue(value.stateVariable!.stateName) as T?;
//     } else if (value.value != null) {
//       dataType = DataTypeCreator.create(
//           Variable(
//               name: '',
//               type: DataType.fromString(value.type),
//               defaultValue: value.value),
//           scopeContext: payload.scopeContext) as T?;
//     }
//     return dataType;
//   }

  // static dynamic _castToType(dynamic value, DataType? type) {
  //   if (type == null || value == null) return value;

  //   switch (type) {
  //     case DataType.timerController:
  //       return value as TimerController;
  //     case DataType.scrollController:
  //       return value as ScrollController;
  //     case DataType.asyncController:
  //       return value as AsyncController;
  //     case DataType.streamController:
  //       return value as StreamController;
  //     case DataType.textEditingController:
  //       return value as TextEditingController;
  //     default:
  //       return value;
  //   }
  // }
// }
