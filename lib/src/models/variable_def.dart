import 'package:json_annotation/json_annotation.dart';

class VariableDef {
  final String type;
  final String name;
  final Object? _defaultValue;
  Object? _value;
  final Map<String, dynamic>? _initializer;

  Object? get value => _value;

  Object? get defaultValue => _defaultValue;

  Map<String, dynamic>? get initializer => _initializer;

  VariableDef(
      {required this.type,
      required this.name,
      Object? defaultValue,
      Map<String, dynamic>? initializer})
      : _value = defaultValue,
        _defaultValue = defaultValue,
        _initializer = initializer;

  void set(Object? value) {
    _value = value;
  }

  void setInitializer(Map<String, dynamic> initializer) {
    _initializer?.addAll(initializer);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'name': name, 'default': _defaultValue};
  }
}

class VariablesJsonConverter
    extends JsonConverter<Map<String, VariableDef>, Map<String, dynamic>> {
  const VariablesJsonConverter();
  @override
  Map<String, VariableDef> fromJson(Map<String, dynamic>? json) {
    if (json == null) return {};

    return json.entries.fold({}, (result, curr) {
      result[curr.key] = VariableDef(
          type: curr.value['type'] as String,
          name: curr.key,
          defaultValue: curr.value['default'],
          initializer: curr.value['initializer']);
      return result;
    });
  }

  @override
  Map<String, dynamic> toJson(Map<String, VariableDef>? object) {
    if (object == null) return {};

    return object.entries.fold({}, (result, curr) {
      result[curr.key] = curr.value.toJson();
      return result;
    });
  }
}
