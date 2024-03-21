import 'package:json_annotation/json_annotation.dart';

part 'dui_wrap_props.g.dart';

@JsonSerializable()
class DUIWrapProps {
  final double? spacing;
  final double? runSpacing;
  final String? wrapAlignment;
  final String? wrapCrossAlignment;
  final String? runAlignment;
  final String? direction;
  final String? verticalDirection;

  DUIWrapProps({
    this.spacing,
    this.runSpacing,
    this.wrapAlignment,
    this.wrapCrossAlignment,
    this.runAlignment,
    this.direction,
    this.verticalDirection,
  });

  factory DUIWrapProps.fromJson(Map<String, dynamic> json) =>
      _$DUIWrapPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIWrapPropsToJson(this);
}
