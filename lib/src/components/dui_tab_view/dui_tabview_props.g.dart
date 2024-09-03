// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_tabview_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITabView1Props _$DUITabView1PropsFromJson(Map<String, dynamic> json) =>
    DUITabView1Props(
      indicatorSize: json['indicatorSize'] as String?,
      initialIndex: json['initialIndex'],
      labelPadding: json['labelPadding'] == null
          ? null
          : DUIInsets.fromJson(json['labelPadding']),
      selectedLabelColor: json['selectedLabelColor'] as String?,
      selectedLabelStyle: DUITextStyle.fromJson(json['selectedLabelStyle']),
      unselectedLabelColor: json['unselectedLabelColor'] as String?,
      unselectedLabelStyle: DUITextStyle.fromJson(json['unselectedLabelStyle']),
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
      'selectedLabelColor': instance.selectedLabelColor,
      'unselectedLabelColor': instance.unselectedLabelColor,
      'dividerHeight': instance.dividerHeight,
      'indicatorColor': instance.indicatorColor,
      'indicatorSize': instance.indicatorSize,
      'tabBarPadding': instance.tabBarPadding,
      'labelPadding': instance.labelPadding,
      'initialIndex': instance.initialIndex,
    };
