// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_container_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIContainerProps _$DUIContainerPropsFromJson(Map<String, dynamic> json) =>
    DUIContainerProps(
      DUIStyleClass.fromJson(json['styleClass']),
      json['width'] as String?,
      json['height'] as String?,
      json['alignment'] as String?,
      DUIInsets.fromJson(json['margin']),
      DUIInsets.fromJson(json['padding']),
      json['color'] as String?,
      json['hasBorder'] as bool?,
      json['borderRadius'] as String?,
      json['borderColor'] as String?,
      json['borderWidth'] as String?,
      json['imageURL'] as String?,
      json['imageOpacity'] as String?,
      json['placeHolder'] as String?,
    );

Map<String, dynamic> _$DUIContainerPropsToJson(DUIContainerProps instance) =>
    <String, dynamic>{
      'placeHolder': instance.placeHolder,
      'width': instance.width,
      'height': instance.height,
      'alignment': instance.alignment,
      'margin': instance.margin,
      'padding': instance.padding,
      'color': instance.color,
      'hasBorder': instance.hasBorder,
      'borderRadius': instance.borderRadius,
      'borderColor': instance.borderColor,
      'borderWidth': instance.borderWidth,
      'imageURL': instance.imageURL,
      'imageOpacity': instance.imageOpacity,
    };
