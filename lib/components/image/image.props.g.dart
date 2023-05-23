// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIImageProps _$DUIImagePropsFromJson(Map<String, dynamic> json) =>
    DUIImageProps()
      ..height = (json['height'] as num?)?.toDouble()
      ..width = (json['width'] as num?)?.toDouble()
      ..imageSrc = json['imageSrc'] as String
      ..placeHolder = json['placeHolder'] as String?
      ..errorFallback = json['errorFallback'] as String?
      ..margin = json['margin'] == null
          ? null
          : DUIInsets.fromJson(json['margin'] as Map<String, dynamic>)
      ..padding = json['padding'] == null
          ? null
          : DUIInsets.fromJson(json['padding'] as Map<String, dynamic>)
      ..fit = json['fit'] as String
      ..cornerRadius = json['cornerRadius'] == null
          ? null
          : DUICornerRadius.fromJson(
              json['cornerRadius'] as Map<String, dynamic>);

Map<String, dynamic> _$DUIImagePropsToJson(DUIImageProps instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'imageSrc': instance.imageSrc,
      'placeHolder': instance.placeHolder,
      'errorFallback': instance.errorFallback,
      'margin': instance.margin,
      'padding': instance.padding,
      'fit': instance.fit,
      'cornerRadius': instance.cornerRadius,
    };
