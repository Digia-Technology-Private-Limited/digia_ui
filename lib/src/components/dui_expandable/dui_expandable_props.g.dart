// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_expandable_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
