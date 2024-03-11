// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_expandable_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIExpandableProps _$DUIExpandablePropsFromJson(Map<String, dynamic> json) =>
    DUIExpandableProps(
      json['bodyAlignment'] as String?,
      json['headerAlignment'] as String?,
      json['iconPlacement'] as String?,
      json['color'] as String?,
      json['padding'] == null ? null : DUIInsets.fromJson(json['padding']),
      json['alignment'] as String?,
      json['animationDuration'] as int?,
      json['collapseIcon'] as Map<String, dynamic>?,
      json['expandIcon'] as Map<String, dynamic>?,
      (json['iconSize'] as num?)?.toDouble(),
      (json['iconRotationAngle'] as num?)?.toDouble(),
      json['hasIcon'] as bool?,
      json['tapHeaderToExpand'] as bool?,
      json['tapBodyToExpand'] as bool?,
      json['tapBodyToCollapse'] as bool?,
      json['useInkWell'] as bool?,
      json['inkWellBorderRadius'] == null
          ? null
          : DUIBorder.fromJson(json['inkWellBorderRadius']),
      json['initialExpanded'] as bool?,
    );

Map<String, dynamic> _$DUIExpandablePropsToJson(DUIExpandableProps instance) =>
    <String, dynamic>{
      'bodyAlignment': instance.bodyAlignment,
      'headerAlignment': instance.headerAlignment,
      'iconPlacement': instance.iconPlacement,
      'color': instance.color,
      'alignment': instance.alignment,
      'padding': instance.padding,
      'animationDuration': instance.animationDuration,
      'collapseIcon': instance.collapseIcon,
      'expandIcon': instance.expandIcon,
      'iconSize': instance.iconSize,
      'iconRotationAngle': instance.iconRotationAngle,
      'hasIcon': instance.hasIcon,
      'tapHeaderToExpand': instance.tapHeaderToExpand,
      'tapBodyToExpand': instance.tapBodyToExpand,
      'tapBodyToCollapse': instance.tapBodyToCollapse,
      'useInkWell': instance.useInkWell,
      'inkWellBorderRadius': instance.inkWellBorderRadius,
      'initialExpanded': instance.initialExpanded,
    };
