// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_tab_view_content_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITabViewContentProps _$DUITabViewContentPropsFromJson(
        Map<String, dynamic> json) =>
    DUITabViewContentProps(
      isScrollable: json['isScrollable'] as bool?,
      viewportFraction: (json['viewportFraction'] as num?)?.toDouble(),
      keepTabsAlive: json['keepTabsAlive'] as bool?,
    );

Map<String, dynamic> _$DUITabViewContentPropsToJson(
        DUITabViewContentProps instance) =>
    <String, dynamic>{
      'isScrollable': instance.isScrollable,
      'viewportFraction': instance.viewportFraction,
      'keepTabsAlive': instance.keepTabsAlive,
    };
