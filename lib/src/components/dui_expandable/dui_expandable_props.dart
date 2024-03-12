import 'package:json_annotation/json_annotation.dart';

import 'package:digia_ui/src/components/utils/DUIBorder/dui_border.dart';
import 'package:digia_ui/src/components/utils/DUIInsets/dui_insets.dart';

part 'dui_expandable_props.g.dart';

class DUIExpandableIconProps {
  final Map<String, dynamic>? collapseIcon;
  final Map<String, dynamic>? expandIcon;
  final double? iconSize;
  final double? iconRotationAngle;
  DUIExpandableIconProps({
    this.collapseIcon,
    this.expandIcon,
    this.iconSize,
    this.iconRotationAngle,
  });
}

@JsonSerializable()
class DUIExpandableProps {
  final String? bodyAlignment;
  final String? headerAlignment;
  final String? iconPlacement;
  final String? color;
  final String? alignment;
  final DUIInsets? padding;
  @JsonKey(fromJson: _iconFromJson, toJson: _iconToJson)
  final DUIExpandableIconProps? icon;
  final int? animationDuration;
  final bool? tapHeaderToExpand;
  final bool? tapBodyToExpand;
  final bool? tapBodyToCollapse;
  final bool? useInkWell;
  final DUIBorder? inkWellBorderRadius;
  final bool? initialExpanded;

  DUIExpandableProps(
      this.bodyAlignment,
      this.headerAlignment,
      this.iconPlacement,
      this.color,
      this.padding,
      this.alignment,
      this.animationDuration,
      this.icon,
      this.tapHeaderToExpand,
      this.tapBodyToExpand,
      this.tapBodyToCollapse,
      this.useInkWell,
      this.inkWellBorderRadius,
      this.initialExpanded);

  factory DUIExpandableProps.fromJson(Map<String, dynamic> json) =>
      _$DUIExpandablePropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIExpandablePropsToJson(this);

  static DUIExpandableIconProps? _iconFromJson(Map<String, dynamic> json) {
    if (json['hasIcon'] != true) {
      return null;
    }

    return DUIExpandableIconProps.fromJson();
  }

  static Map<String, dynamic> _iconToJson(DUIExpandableIconProps? object) {
    if (object == null) {
      return {
        'hasIcon': false,
      };
    }

    return {'hasIcon': true, ...?object.toJson()};
  }
}
