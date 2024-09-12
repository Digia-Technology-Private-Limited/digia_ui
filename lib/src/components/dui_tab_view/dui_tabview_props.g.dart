// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_tabview_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITabView1Props _$DUITabView1PropsFromJson(Map<String, dynamic> json) =>
    DUITabView1Props(
      animationType: json['animationType'] as String?,
      tabBarScrollable: json['tabBarScrollable'] as Map<String, dynamic>?,
      indicatorSize: json['indicatorSize'] as String?,
      labelPadding: json['labelPadding'] == null
          ? null
          : DUIInsets.fromJson(json['labelPadding']),
      dividerHeight: (json['dividerHeight'] as num?)?.toDouble(),
      indicatorColor: json['indicatorColor'] as String?,
      dividerColor: json['dividerColor'] as String?,
      tabBarPadding: json['tabBarPadding'] == null
          ? null
          : DUIInsets.fromJson(json['tabBarPadding']),
    );

Map<String, dynamic> _$DUITabView1PropsToJson(DUITabView1Props instance) =>
    <String, dynamic>{
      'dividerColor': instance.dividerColor,
      'dividerHeight': instance.dividerHeight,
      'indicatorColor': instance.indicatorColor,
      'indicatorSize': instance.indicatorSize,
      'tabBarPadding': instance.tabBarPadding,
      'labelPadding': instance.labelPadding,
      'animationType': instance.animationType,
      'tabBarScrollable': instance.tabBarScrollable,
    };
