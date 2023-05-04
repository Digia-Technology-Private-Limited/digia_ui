// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIImageProps _$DUIImagePropsFromJson(Map<String, dynamic> json) =>
    DUIImageProps()
      ..height = (json['height'] as num).toDouble()
      ..width = (json['width'] as num).toDouble()
      ..imageSrc = json['imageSrc'] as String
      ..aspectRatio = json['aspectRatio'] as int?
      ..placeHolder = json['placeHolder'] as String?
      ..errorFallback = json['errorFallback'] as String?
      ..margins = json['margins'] == null
          ? null
          : DUIInsets.fromJson(json['margins'] as Map<String, dynamic>)
      ..fit = DUIFit.fromJson(json['fit'] as Map<String, dynamic>)
      ..cornerRadius = json['cornerRadius'] == null
          ? null
          : DUICornerRadius.fromJson(
              json['cornerRadius'] as Map<String, dynamic>);

Map<String, dynamic> _$DUIImagePropsToJson(DUIImageProps instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'imageSrc': instance.imageSrc,
      'aspectRatio': instance.aspectRatio,
      'placeHolder': instance.placeHolder,
      'errorFallback': instance.errorFallback,
      'margins': instance.margins,
      'fit': instance.fit,
      'cornerRadius': instance.cornerRadius,
    };
