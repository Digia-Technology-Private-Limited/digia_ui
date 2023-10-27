import 'package:digia_ui/components/DUIText/dui_text_props.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_bar.props.g.dart';

@JsonSerializable()
class DUIAppBarProps {
  final DUITextProps title;
  final double _elevation;
  final String? shadowColor;
  final String? backgrounColor;
  final String? iconColor;

  double get elevation => _elevation;

  DUIAppBarProps(
      {required this.title,
      this.shadowColor,
      this.backgrounColor,
      this.iconColor,
      double? elevation})
      : _elevation = elevation ?? 0;

  factory DUIAppBarProps.fromJson(Map<String, dynamic> json) =>
      _$DUIAppBarPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIAppBarPropsToJson(this);
}
