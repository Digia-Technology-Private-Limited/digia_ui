import 'package:digia_ui/src/components/utils/DUIBorder/dui_border.dart';
import 'package:digia_ui/src/components/utils/DUIInsets/dui_insets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_expandable_props.g.dart';

@JsonSerializable()
class DUIExpandableProps {
  final Map<String, dynamic>? expanded;
  final Map<String, dynamic>? collapsed;
  final String? bodyAlignment;
  final String? headerAlignment;
  final String? iconPlacement;
  final String? color;
  final String? alignment;
  final DUIInsets? padding;
  final int? animationDuration;
  final Map<String, dynamic>? collapseIcon;
  final Map<String, dynamic>? expandIcon;
  final double? iconSize;
  final double? iconRotationAngle;
  final bool? hasIcon;
  final bool? tapHeaderToExpand;
  final bool? tapBodyToExpand;
  final bool? tapBodyToCollapse;
  final bool? useInkWell;
  final DUIBorder? inkWellBorderRadius;
  final bool? initialExpanded;

  DUIExpandableProps(
      this.expanded,
      this.collapsed,
      this.bodyAlignment,
      this.headerAlignment,
      this.iconPlacement,
      this.color,
      this.padding,
      this.alignment,
      this.animationDuration,
      this.collapseIcon,
      this.expandIcon,
      this.iconSize,
      this.iconRotationAngle,
      this.hasIcon,
      this.tapHeaderToExpand,
      this.tapBodyToExpand,
      this.tapBodyToCollapse,
      this.useInkWell,
      this.inkWellBorderRadius, this.initialExpanded);

  factory DUIExpandableProps.fromJson(Map<String, dynamic> json) =>
      _$DUIExpandablePropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIExpandablePropsToJson(this);
}
