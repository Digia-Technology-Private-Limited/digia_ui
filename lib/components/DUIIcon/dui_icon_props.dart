import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DUIIconProps {
  final String value;
  final dynamic size;
  final String color;
  DUIIconProps({
    required this.value,
    required this.size,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'size': size,
      'color': color,
    };
  }

  factory DUIIconProps.fromMap(Map<String, dynamic> map) {
    return DUIIconProps(
      value: map['value'] as String,
      size: map['size'] as dynamic,
      color: map['color'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DUIIconProps.fromJson(String source) =>
      DUIIconProps.fromMap(json.decode(source) as Map<String, dynamic>);
}
