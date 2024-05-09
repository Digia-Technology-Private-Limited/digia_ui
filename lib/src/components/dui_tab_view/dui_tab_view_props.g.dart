// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_tab_view_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITabViewProps _$DUITabViewPropsFromJson(Map<String, dynamic> json) => DUITabViewProps(
      hasTabs: json['hasTabs'] as bool?,
      selectedLabelColor: json['selectedLabelColor'] as String?,
      selectedLabelStyle: DUITextStyle.fromJson(json['selectedLabelStyle']),
      unselectedLabelColor: json['unselectedLabelColor'] as String?,
      unselectedLabelStyle: DUITextStyle.fromJson(json['unselectedLabelStyle']),
      dividerHeight: (json['dividerHeight'] as num?)?.toDouble(),
      indicatorColor: json['indicatorColor'] as String?,
      dividerColor: json['dividerColor'] as String?,
      tabBarPosition: json['tabBarPosition'] as String?,
      isScrollable: json['isScrollable'] as bool?,
      viewportFraction: (json['viewportFraction'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DUITabViewPropsToJson(DUITabViewProps instance) => <String, dynamic>{
      'hasTabs': instance.hasTabs,
      'dividerColor': instance.dividerColor,
      'tabBarPosition': instance.tabBarPosition,
      'selectedLabelColor': instance.selectedLabelColor,
      'unselectedLabelColor': instance.unselectedLabelColor,
      'dividerHeight': instance.dividerHeight,
      'isScrollable': instance.isScrollable,
      'indicatorColor': instance.indicatorColor,
      'viewportFraction': instance.viewportFraction,
    };
