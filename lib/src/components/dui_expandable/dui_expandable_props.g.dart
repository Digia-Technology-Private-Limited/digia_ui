// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_expandable_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIExpandableIconProps _$DUIExpandableIconPropsFromJson(
        Map<String, dynamic> json) =>
    DUIExpandableIconProps(
      iconPadding: json['iconPadding'] == null
          ? null
          : DUIInsets.fromJson(json['iconPadding']),
      collapseIcon: json['collapseIcon'] as Map<String, dynamic>?,
      expandIcon: json['expandIcon'] as Map<String, dynamic>?,
      iconPlacement: json['iconPlacement'] as String?,
      iconSize: (json['iconSize'] as num?)?.toDouble(),
      iconRotationAngle: (json['iconRotationAngle'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DUIExpandableIconPropsToJson(
        DUIExpandableIconProps instance) =>
    <String, dynamic>{
      'collapseIcon': instance.collapseIcon,
      'expandIcon': instance.expandIcon,
      'iconPlacement': instance.iconPlacement,
      'iconPadding': instance.iconPadding,
      'iconSize': instance.iconSize,
      'iconRotationAngle': instance.iconRotationAngle,
    };

DUIExpandableProps _$DUIExpandablePropsFromJson(Map<String, dynamic> json) =>
    DUIExpandableProps(
      json['bodyAlignment'] as String?,
      json['headerAlignment'] as String?,
      json['color'] as String?,
      json['alignment'] as String?,
      json['animationDuration'] as int?,
      DUIExpandableProps._iconFromJson(json['icon'] as Map<String, dynamic>),
      json['tapHeaderToExpand'] as bool?,
      json['tapBodyToExpand'] as bool?,
      json['tapBodyToCollapse'] as bool?,
      json['useInkWell'] as bool?,
      (json['inkWellBorderRadius'] as num?)?.toDouble(),
      json['initiallyExpanded'] as bool?,
    );

Map<String, dynamic> _$DUIExpandablePropsToJson(DUIExpandableProps instance) =>
    <String, dynamic>{
      'bodyAlignment': instance.bodyAlignment,
      'headerAlignment': instance.headerAlignment,
      'color': instance.color,
      'alignment': instance.alignment,
      'icon': DUIExpandableProps._iconToJson(instance.icon),
      'animationDuration': instance.animationDuration,
      'tapHeaderToExpand': instance.tapHeaderToExpand,
      'tapBodyToExpand': instance.tapBodyToExpand,
      'tapBodyToCollapse': instance.tapBodyToCollapse,
      'useInkWell': instance.useInkWell,
      'inkWellBorderRadius': instance.inkWellBorderRadius,
      'initiallyExpanded': instance.initiallyExpanded,
    };
