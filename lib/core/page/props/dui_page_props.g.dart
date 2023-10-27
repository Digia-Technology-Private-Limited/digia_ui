// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_page_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIPageProps _$DUIPagePropsFromJson(Map<String, dynamic> json) => DUIPageProps(
      uid: json['uid'] as String,
      actions: json['actions'],
      inputArgs: json['inputArgs'],
      layout: json['layout'] == null
          ? null
          : PageLayoutProps.fromJson(json['layout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DUIPagePropsToJson(DUIPageProps instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'actions': instance.actions,
      'inputArgs': instance.inputArgs,
      'layout': instance.layout,
    };

PageLayoutProps _$PageLayoutPropsFromJson(Map<String, dynamic> json) =>
    PageLayoutProps(
      header: _$recordConvertNullable(
        json['header'],
        ($jsonValue) => (
          root: $jsonValue['root'] == null
              ? null
              : DUIWidgetJsonData.fromJson(
                  $jsonValue['root'] as Map<String, dynamic>),
        ),
      ),
      body: PageBody.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PageLayoutPropsToJson(PageLayoutProps instance) =>
    <String, dynamic>{
      'header': instance.header == null
          ? null
          : {
              'root': instance.header!.root,
            },
      'body': instance.body,
    };

$Rec? _$recordConvertNullable<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    value == null ? null : convert(value as Map<String, dynamic>);

PageBody _$PageBodyFromJson(Map<String, dynamic> json) => PageBody(
      root: DUIWidgetJsonData.fromJson(json['root'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PageBodyToJson(PageBody instance) => <String, dynamic>{
      'root': instance.root,
    };
