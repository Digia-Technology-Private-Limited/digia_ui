// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIAvatarProps _$DUIAvatarPropsFromJson(Map<String, dynamic> json) =>
    DUIAvatarProps(
      cornerRadius: json['cornerRadius'] == null
          ? null
          : DUICornerRadius.fromJson(json['cornerRadius']),
      radius: (json['radius'] as num?)?.toDouble(),
      side: (json['side'] as num?)?.toDouble(),
      bgColor: json['bgColor'] as String?,
      imageSrc: json['imageSrc'] as String?,
      text: json['text'] == null ? null : DUITextProps.fromJson(json['text']),
      imageFit: json['imageFit'] as String?,
      shape: $enumDecodeNullable(_$AvatarShapeEnumMap, json['shape']),
    );

Map<String, dynamic> _$DUIAvatarPropsToJson(DUIAvatarProps instance) =>
    <String, dynamic>{
      'cornerRadius': instance.cornerRadius,
      'imageSrc': instance.imageSrc,
      'imageFit': instance.imageFit,
      'text': instance.text,
      'bgColor': instance.bgColor,
      'radius': instance.radius,
      'shape': _$AvatarShapeEnumMap[instance.shape]!,
      'side': instance.side,
    };

const _$AvatarShapeEnumMap = {
  AvatarShape.circle: 'circle',
  AvatarShape.square: 'square',
};
