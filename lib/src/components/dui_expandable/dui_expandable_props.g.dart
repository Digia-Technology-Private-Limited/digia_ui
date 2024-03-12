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
      (json['iconRotationAngle'] as num?)?.toDouble(),
      json['hasIcon'] as bool?,
      json['tapBodyToExpand'] as bool?,
      json['tapBodyToCollapse'] as bool?,
      json['useInkWell'] as bool?,
      json['inkWellBorderRadius'] as double?,
      json['initiallyExpanded'] as bool?,
    );

Map<String, dynamic> _$DUIExpandablePropsToJson(DUIExpandableProps instance) =>
    <String, dynamic>{
      'bodyAlignment': instance.bodyAlignment,
      'headerAlignment': instance.headerAlignment,
      'color': instance.color,
      'alignment': instance.alignment,
      'animationDuration': instance.animationDuration,
      'tapHeaderToExpand': instance.tapHeaderToExpand,
      'tapBodyToExpand': instance.tapBodyToExpand,
      'tapBodyToCollapse': instance.tapBodyToCollapse,
      'useInkWell': instance.useInkWell,
      'inkWellBorderRadius': instance.inkWellBorderRadius,
      'initiallyExpanded': instance.initiallyExpanded,
    };
