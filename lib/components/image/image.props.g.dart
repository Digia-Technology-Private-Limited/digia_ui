// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIImageProps _$DUIImagePropsFromJson(Map<String, dynamic> json) =>
    DUIImageProps()
      ..height = (json['height'] as num).toDouble()
      ..width = (json['width'] as num).toDouble()
      ..imageSrc = json['imageSrc'] as String;

Map<String, dynamic> _$DUIImagePropsToJson(DUIImageProps instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'imageSrc': instance.imageSrc,
    };
