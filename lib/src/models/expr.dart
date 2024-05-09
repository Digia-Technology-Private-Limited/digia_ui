import 'package:digia_ui/src/Utils/extensions.dart';
import 'package:json_annotation/json_annotation.dart';

class ExprOr<T> {
  final T? value;
  final String? expr;

  bool get isNil => value == null && expr == null;

  const ExprOr({required this.value, this.expr});

  factory ExprOr.nil() => const ExprOr(value: null, expr: null);
}

typedef FromJson<T> = T? Function(Object? json);
typedef ToJson<T> = dynamic Function(T object);

class ExprJsonConv<T> extends JsonConverter<ExprOr<T>, Object?> {
  final FromJson<T>? _fromJsonT;
  final ToJson<T>? _toJson;
  final T? defaultValue;

  const ExprJsonConv({FromJson<T>? fromJson, ToJson<T>? toJson, this.defaultValue})
      : _fromJsonT = fromJson,
        _toJson = toJson;

  @override
  ExprOr<T> fromJson(Object? json) {
    if (json == null) return ExprOr.nil();

    if (json is String) {
      return ExprOr(expr: json, value: null);
    }

    return ExprOr(value: _fromJsonT?.call(json) ?? json.typedValue<T>() ?? defaultValue);
  }

  @override
  Object? toJson(ExprOr<T> object) {
    if (object.expr != null) return object.expr;

    final value = object.value;

    if (value == null) return null;

    if (value is String || value is int || value is double || value is bool) {
      return value;
    }

    return _toJson?.call(value);
  }
}
