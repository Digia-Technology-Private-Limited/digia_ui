import 'package:json_annotation/json_annotation.dart';
part 'dui_icon_props.g.dart';

@JsonSerializable()
class DUIIconProps {
  Map<String, dynamic>? iconData;
  double? iconSize;
  String? iconColor;

  DUIIconProps({
    this.iconSize,
    this.iconColor,
    this.iconData,
  });

  factory DUIIconProps.fromJson(dynamic json) => _$DUIIconPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIIconPropsToJson(this);
}
