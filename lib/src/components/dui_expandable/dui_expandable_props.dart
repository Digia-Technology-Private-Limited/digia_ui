import 'package:digia_ui/src/components/utils/DUIInsets/dui_insets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_expandable_props.g.dart';

class DUIExpandableIconProps {
  final Map<String, dynamic>? collapseIcon;
  final Map<String, dynamic>? expandIcon;
  final String? iconPlacement;
  final DUIInsets? iconPadding;
  final double? iconSize;
  final double? iconRotationAngle;

  DUIExpandableIconProps({
    this.iconPadding,
    this.collapseIcon,
    this.expandIcon,
    this.iconPlacement,
    this.iconSize,
    this.iconRotationAngle,
  });

  factory DUIExpandableIconProps.fromJson(Map<String, dynamic> json) {
    return DUIExpandableIconProps(
      iconPadding: json['iconPadding'] == null
          ? null
          : DUIInsets.fromJson(json['iconPadding']),
      collapseIcon: json['collapseIcon'] as Map<String, dynamic>?,
      expandIcon: json['expandIcon'] as Map<String, dynamic>?,
      iconPlacement: json['alignment'] as String?,
      iconRotationAngle: (json['iconRotationAngle'] as num?)?.toDouble(),
      iconSize: (json['iconSize'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iconPlacement': iconPlacement,
      'collapseIcon': collapseIcon,
      'expandIcon': expandIcon,
      'iconSize': iconSize,
      'iconRotationAngle': iconRotationAngle,
      'padding': iconPadding,
    };
  }
}

@JsonSerializable()
class DUIExpandableProps {
  final String? bodyAlignment;
  final String? headerAlignment;
  final String? color;
  final String? alignment;
  @JsonKey(fromJson: _iconFromJson, toJson: _iconToJson)
  final DUIExpandableIconProps? icon;
  final int? animationDuration;
  final bool? tapHeaderToExpand;
  final bool? tapBodyToExpand;
  final bool? tapBodyToCollapse;
  final bool? useInkWell;
  final double? inkWellBorderRadius;
  final bool? initiallyExpanded;

  DUIExpandableProps(
      this.bodyAlignment,
      this.headerAlignment,
      this.color,
      this.alignment,
      this.animationDuration,
      this.icon,
      this.tapHeaderToExpand,
      this.tapBodyToExpand,
      this.tapBodyToCollapse,
      this.useInkWell,
      this.inkWellBorderRadius,
      this.initiallyExpanded);

  factory DUIExpandableProps.fromJson(Map<String, dynamic> json) =>
      _$DUIExpandablePropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIExpandablePropsToJson(this);

  static DUIExpandableIconProps? _iconFromJson(Map<String, dynamic> json) {
    if (json['hasIcon'] != true) {
      return null;
    }

    return DUIExpandableIconProps.fromJson(json);
  }

  static Map<String, dynamic> _iconToJson(DUIExpandableIconProps? object) {
    if (object == null) {
      return {
        'hasIcon': false,
      };
    }

    return {'hasIcon': true, ...object.toJson()};
  }
}
