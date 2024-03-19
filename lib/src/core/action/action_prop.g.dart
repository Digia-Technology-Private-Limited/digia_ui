// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_prop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionProp _$ActionPropFromJson(Map<String, dynamic> json) => ActionProp(
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
      inkwell: json['inkwell'] as bool? ?? true,
    );

Map<String, dynamic> _$ActionPropToJson(ActionProp instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
      'inkwell': instance.inkwell,
    };
