// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_tab_bar_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITabBarProps _$DUITabBarPropsFromJson(Map<String, dynamic> json) =>
    DUITabBarProps(
      animationType: json['animationType'] as String?,
      tabBarScrollable: json['tabBarScrollable'] as Map<String, dynamic>?,
      indicatorSize: json['indicatorSize'] as String?,
      labelPadding: json['labelPadding'] == null
          ? null
          : DUIInsets.fromJson(json['labelPadding']),
      dividerHeight: (json['dividerHeight'] as num?)?.toDouble(),
      indicatorWeight: (json['indicatorWeight'] as num?)?.toDouble(),
      indicatorColor: json['indicatorColor'] as String?,
      dividerColor: json['dividerColor'] as String?,
      tabBarPadding: json['tabBarPadding'] == null
          ? null
          : DUIInsets.fromJson(json['tabBarPadding']),
    );

Map<String, dynamic> _$DUITabBarPropsToJson(DUITabBarProps instance) =>
    <String, dynamic>{
      'dividerColor': instance.dividerColor,
      'dividerHeight': instance.dividerHeight,
      'indicatorWeight': instance.indicatorWeight,
      'indicatorColor': instance.indicatorColor,
      'indicatorSize': instance.indicatorSize,
      'tabBarPadding': instance.tabBarPadding,
      'labelPadding': instance.labelPadding,
      'animationType': instance.animationType,
      'tabBarScrollable': instance.tabBarScrollable,
    };
