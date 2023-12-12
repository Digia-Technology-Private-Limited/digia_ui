// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIAvatarProps _$DUIAvatarPropsFromJson(Map<String, dynamic> json) =>
    DUIAvatarProps(
      bgColor: json['bgColor'] as String?,
      imageSrc: json['imageSrc'] as String?,
      text: json['text'] == null ? null : DUITextProps.fromJson(json['text']),
      imageFit: json['imageFit'] as String?,
      shape: $enumDecodeNullable(_$AvatarShapeEnumMap, json['shape']),
      shape: AvatarShape.fromJson(json['shape'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$DUIAvatarPropsToJson(DUIAvatarProps instance) =>
    <String, dynamic>{
      'cornerRadius': instance.cornerRadius,
      'shape': AvatarShape.toJson(instance.shape),
      'imageSrc': instance.imageSrc,
      'imageFit': instance.imageFit,
      'text': instance.text,
      'bgColor': instance.bgColor,
      'radius': instance.radius,
      'shape': _$AvatarShapeEnumMap[instance.shape]!,
      'side': instance.side,
    };
