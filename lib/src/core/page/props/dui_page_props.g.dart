// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_page_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIPageProps _$DUIPagePropsFromJson(Map<String, dynamic> json) => DUIPageProps(
      uid: json['uid'] as String,
      actions: json['actions'],
      inputArgs: json['inputArgs'],
      layout: const PageLayoutJsonConverter()
          .fromJson(json['layout'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$DUIPagePropsToJson(DUIPageProps instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'actions': instance.actions,
      'inputArgs': instance.inputArgs,
      'layout': const PageLayoutJsonConverter().toJson(instance.layout),
    };

PageBody _$PageBodyFromJson(Map<String, dynamic> json) => PageBody(
      root: DUIWidgetJsonData.fromJson(json['root'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PageBodyToJson(PageBody instance) => <String, dynamic>{
      'root': instance.root,
    };
