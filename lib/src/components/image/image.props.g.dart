// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIImageProps _$DUIImagePropsFromJson(Map<String, dynamic> json) =>
    DUIImageProps(
      styleClass: DUIStyleClass.fromJson(json['styleClass']),
      imageSrc: json['imageSrc'] as String,
      placeHolder: json['placeHolder'] as String?,
      errorImage: json['errorImage'] as String?,
      aspectRatio: (json['aspectRatio'] as num?)?.toDouble(),
      fit: json['fit'] as String?,
      opacity: (json['opacity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DUIImagePropsToJson(DUIImageProps instance) =>
    <String, dynamic>{
      'imageSrc': instance.imageSrc,
      'placeHolder': instance.placeHolder,
      'errorImage': instance.errorImage,
      'aspectRatio': instance.aspectRatio,
      'fit': instance.fit,
      'opacity': instance.opacity,
    };
