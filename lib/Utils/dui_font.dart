import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'dui_font.g.dart';

@JsonSerializable()
class DUIFont {
  late String? weight;
  late double? size;
  late double? height;
  late String? style;
  late String? fontFamily;

  DUIFont();
  factory DUIFont.fromJson(Map<String, dynamic> json) =>
      _$DUIFontFromJson(json);

  Map<String, dynamic> toJson() => _$DUIFontToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
