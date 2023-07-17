// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_page_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIPageProps _$DUIPagePropsFromJson(Map<String, dynamic> json) => DUIPageProps()
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..actions = json['actions']
  ..layout = PageLayoutProps.fromJson(json['layout'] as Map<String, dynamic>);

Map<String, dynamic> _$DUIPagePropsToJson(DUIPageProps instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'actions': instance.actions,
      'layout': instance.layout,
    };

PageLayoutProps _$PageLayoutPropsFromJson(Map<String, dynamic> json) =>
    PageLayoutProps()
      ..header = json['header'] as Map<String, dynamic>?
      ..body = PageBody.fromJson(json['body'] as Map<String, dynamic>);

Map<String, dynamic> _$PageLayoutPropsToJson(PageLayoutProps instance) =>
    <String, dynamic>{
      'header': instance.header,
      'body': instance.body,
    };

PageBody _$PageBodyFromJson(Map<String, dynamic> json) => PageBody()
  ..allowScroll = json['allowScroll'] as bool?
  ..list = PageBodyList.fromJson(json['list'] as Map<String, dynamic>);

Map<String, dynamic> _$PageBodyToJson(PageBody instance) => <String, dynamic>{
      'allowScroll': instance.allowScroll,
      'list': instance.list,
    };

PageBodyList _$PageBodyListFromJson(Map<String, dynamic> json) => PageBodyList(
      children: (json['children'] as List<dynamic>?)
              ?.map((e) =>
                  PageBodyListContainer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )..styleClass = DUIStyleClass.fromJson(json['styleClass']);

Map<String, dynamic> _$PageBodyListToJson(PageBodyList instance) =>
    <String, dynamic>{
      'children': instance.children,
    };

PageBodyListContainer _$PageBodyListContainerFromJson(
        Map<String, dynamic> json) =>
    PageBodyListContainer(
      alignChild: json['alignChild'] as String?,
    )
      ..styleClass = DUIStyleClass.fromJson(json['styleClass'])
      ..child =
          PageBodyListChild.fromJson(json['child'] as Map<String, dynamic>);

Map<String, dynamic> _$PageBodyListContainerToJson(
        PageBodyListContainer instance) =>
    <String, dynamic>{
      'alignChild': instance.alignChild,
      'child': instance.child,
    };

PageBodyListChild _$PageBodyListChildFromJson(Map<String, dynamic> json) =>
    PageBodyListChild()
      ..type = json['type'] as String
      ..data = json['data'] as Map<String, dynamic>;

Map<String, dynamic> _$PageBodyListChildToJson(PageBodyListChild instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
    };
