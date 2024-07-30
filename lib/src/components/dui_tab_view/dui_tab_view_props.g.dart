// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_tab_view_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITabViewProps _$DUITabViewPropsFromJson(Map<String, dynamic> json) =>
    DUITabViewProps(
      hasTabs: json['hasTabs'] as bool?,
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
      tabBarPosition: json['tabBarPosition'] as String?,
      isScrollable: json['isScrollable'] as bool?,
      viewportFraction: (json['viewportFraction'] as num?)?.toDouble(),
      tabBarPadding: json['tabBarPadding'] == null
          ? null
          : DUIInsets.fromJson(json['tabBarPadding']),
      tabPadding: json['tabPadding'] == null
          ? null
          : DUIInsets.fromJson(json['tabPadding']),
      selectedBgColor: json['selectedBgColor'] as String?,
      nonSelectedBgColor: json['nonSelectedBgColor'] as String?,
      borderColor: json['borderColor'] as String?,
      borderWidth: (json['borderWidth'] as num?)?.toDouble(),
      isIconAtLeft: json['isIconAtLeft'] as bool?,
      borderRadius: json['borderRadius'] as String?,
      tabAlignment: json['tabAlignment'] as String?,
    );

Map<String, dynamic> _$DUITabViewPropsToJson(DUITabViewProps instance) =>
    <String, dynamic>{
      'hasTabs': instance.hasTabs,
      'dividerColor': instance.dividerColor,
      'tabBarPosition': instance.tabBarPosition,
      'selectedLabelColor': instance.selectedLabelColor,
      'unselectedLabelColor': instance.unselectedLabelColor,
      'dividerHeight': instance.dividerHeight,
      'isScrollable': instance.isScrollable,
      'indicatorColor': instance.indicatorColor,
      'indicatorSize': instance.indicatorSize,
      'viewportFraction': instance.viewportFraction,
      'tabBarPadding': instance.tabBarPadding,

      'tabPadding': instance.tabPadding,
      'selectedBgColor': instance.selectedBgColor,
      'nonSelectedBgColor': instance.nonSelectedBgColor,
      'borderColor': instance.borderColor,
      'borderWidth': instance.borderWidth,
      'isIconAtLeft': instance.isIconAtLeft,
      'borderRadius': instance.borderRadius,
      'tabAlignment': instance.tabAlignment,

      'labelPadding': instance.labelPadding,
      'initialIndex': instance.initialIndex,

    };
