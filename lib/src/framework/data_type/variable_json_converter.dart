import 'package:json_annotation/json_annotation.dart';

import 'variable.dart';

class VariableJsonConverter
    extends JsonConverter<Map<String, Variable>, Map<String, Object?>> {
  const VariableJsonConverter();

  @override
  Map<String, Variable> fromJson(Map<String, Object?>? json) {
    if (json == null) return {};

    return json.entries.fold({}, (result, curr) {
      final v = Variable.fromJson({
        'name': curr.key,
        ...?(curr.value as Map<String, Object?>?),
      });

      if (v != null) {
        result[curr.key] = v;
      }
      return result;
    });
  }

  @override
  Map<String, Object?> toJson(Map<String, Variable>? object) {
    if (object == null) return {};

    return object.entries.fold({}, (result, curr) {
      result[curr.key] = curr.value.toJson();
      return result;
    });
  }
}
