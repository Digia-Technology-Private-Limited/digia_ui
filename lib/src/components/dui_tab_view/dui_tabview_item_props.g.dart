// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_tabview_item_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITabViewItem1Props _$DUITabViewItem1PropsFromJson(
        Map<String, dynamic> json) =>
    DUITabViewItem1Props(
      isScrollable: json['isScrollable'] as bool?,
      viewportFraction: (json['viewportFraction'] as num?)?.toDouble(),
      allDynamic: json['allDynamic'] as bool?,
    );

Map<String, dynamic> _$DUITabViewItem1PropsToJson(
        DUITabViewItem1Props instance) =>
    <String, dynamic>{
      'isScrollable': instance.isScrollable,
      'viewportFraction': instance.viewportFraction,
      'allDynamic': instance.allDynamic,
    };
