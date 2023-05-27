// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_grid_view.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIGridViewProps _$DUIGridViewPropsFromJson(Map<String, dynamic> json) =>
    DUIGridViewProps(
      children: (json['children'] as List<dynamic>?)
              ?.map((e) =>
                  PageBodyListContainer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )
      ..mainAxisSpacing = json['mainAxisSpacing'] as String?
      ..crossAxisSpacing = json['crossAxisSpacing'] as String?
      ..crossAxisCount = json['crossAxisCount'] as int;

Map<String, dynamic> _$DUIGridViewPropsToJson(DUIGridViewProps instance) =>
    <String, dynamic>{
      'mainAxisSpacing': instance.mainAxisSpacing,
      'crossAxisSpacing': instance.crossAxisSpacing,
      'crossAxisCount': instance.crossAxisCount,
      'children': instance.children,
    };
