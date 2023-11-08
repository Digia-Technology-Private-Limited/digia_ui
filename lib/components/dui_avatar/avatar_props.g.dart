// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIAvatarProps _$DUIAvatarPropsFromJson(Map<String, dynamic> json) =>
    DUIAvatarProps(
      radius: json['radius'] == null
          ? null
          : DUICornerRadius.fromJson(json['radius']),
      bgColor: json['bgColor'] as String?,
      imageSrc: json['imageSrc'] as String?,
      fallbackText: json['fallbackText'] == null
          ? null
          : DUITextProps.fromJson(json['fallbackText']),
      shape: $enumDecodeNullable(_$AvatarShapeEnumMap, json['shape']),
    );

Map<String, dynamic> _$DUIAvatarPropsToJson(DUIAvatarProps instance) =>
    <String, dynamic>{
      'radius': instance.radius,
      'bgColor': instance.bgColor,
      'imageSrc': instance.imageSrc,
      'fallbackText': instance.fallbackText,
      'shape': _$AvatarShapeEnumMap[instance.shape]!,
    };

const _$AvatarShapeEnumMap = {
  AvatarShape.circle: 'circle',
  AvatarShape.square: 'square',
};
