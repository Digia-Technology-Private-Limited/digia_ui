import 'package:json_annotation/json_annotation.dart';

part 'dui_font.g.dart';

@JsonSerializable()
class DUIFont {
  String? weight;
  double? size;
  double? height;
  String? style;
  @JsonKey(name: 'font-family')
  String? fontFamily;

  DUIFont({this.weight, this.size, this.height, this.style, this.fontFamily});

  factory DUIFont.fromJson(Map<String, dynamic> json) => _$DUIFontFromJson(json);

  Map<String, dynamic> toJson() => _$DUIFontToJson(this);

  DUIFont merge(DUIFont? font) {
    return DUIFont(
        weight: font?.weight ?? weight,
        size: font?.size ?? size,
        height: font?.height ?? height,
        style: font?.style ?? style,
        fontFamily: font?.fontFamily ?? fontFamily);
  }
}
