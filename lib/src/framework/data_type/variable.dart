import '../utils/json_util.dart';
import '../utils/types.dart';
import 'data_type.dart';

class Variable {
  final DataType type;
  final String name;
  final Object? defaultValue;

  const Variable({
    required this.name,
    required this.type,
    this.defaultValue,
  });

  static Variable? fromJson(JsonLike? json) {
    if (json == null) return null;

    final type = DataType.fromString(json['type'] as String?);
    final name = json['name'] as String?;

    if (type == null || name == null) return null;

    return Variable(
      name: name,
      type: type,
      defaultValue: tryKeys<Object?>(json, ['default', 'defaultValue']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.id,
      'name': name,
      'default': defaultValue,
    };
  }
}
