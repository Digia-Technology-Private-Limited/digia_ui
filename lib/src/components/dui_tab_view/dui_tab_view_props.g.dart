// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_tab_view_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITabViewProps _$DUITabViewPropsFromJson(Map<String, dynamic> json) =>
    DUITabViewProps(
      iconPosition: json['iconPosition'] as String?,
      tabBarScrollable: json['tabBarScrollable'] as Map<String, dynamic>?,
      buttonProps: json['buttonProps'] as Map<String, dynamic>?,
      indicatorProps: json['indicatorProps'] as Map<String, dynamic>?,
      hasTabs: json['hasTabs'] as bool?,
      initialIndex: json['initialIndex'],
      labelPadding: json['labelPadding'] == null
          ? null
          : DUIInsets.fromJson(json['labelPadding']),
      selectedLabelColor: json['selectedLabelColor'] as String?,
      selectedLabelStyle: DUITextStyle.fromJson(json['selectedLabelStyle']),
      unselectedLabelColor: json['unselectedLabelColor'] as String?,
      unselectedLabelStyle: DUITextStyle.fromJson(json['unselectedLabelStyle']),
      isScrollable: json['isScrollable'] as bool?,
      viewportFraction: (json['viewportFraction'] as num?)?.toDouble(),
      tabBarPadding: json['tabBarPadding'] == null
          ? null
          : DUIInsets.fromJson(json['tabBarPadding']),
    );

Map<String, dynamic> _$DUITabViewPropsToJson(DUITabViewProps instance) =>
    <String, dynamic>{
      'hasTabs': instance.hasTabs,
      'iconPosition': instance.iconPosition,
      'selectedLabelColor': instance.selectedLabelColor,
      'unselectedLabelColor': instance.unselectedLabelColor,
      'isScrollable': instance.isScrollable,
      'viewportFraction': instance.viewportFraction,
      'tabBarPadding': instance.tabBarPadding,
      'labelPadding': instance.labelPadding,
      'initialIndex': instance.initialIndex,
      'tabBarScrollable': instance.tabBarScrollable,
      'buttonProps': instance.buttonProps,
      'indicatorProps': instance.indicatorProps,
    };
