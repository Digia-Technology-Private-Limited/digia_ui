// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_container2_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIContainer2Props _$DUIContainer2PropsFromJson(Map<String, dynamic> json) =>
    DUIContainer2Props(
      json['width'] as String?,
      json['height'] as String?,
      json['margin'] == null ? null : DUIInsets.fromJson(json['margin']),
      json['padding'] == null ? null : DUIInsets.fromJson(json['padding']),
      json['color'] as String?,
      json['maxHeight'] as String?,
      json['minHeight'] as String?,
      json['maxWidth'] as String?,
      json['minWidth'] as String?,
      json['shape'] as String?,
      json['childAlignment'] as String?,
      json['border'] == null ? null : DUIBorder.fromJson(json['border']),
      json['decorationImage'] == null
          ? null
          : DUIDecorationImage.fromJson(
              json['decorationImage'] as Map<String, dynamic>),
      json['boxFit'] as String?,
    );

Map<String, dynamic> _$DUIContainer2PropsToJson(DUIContainer2Props instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'maxHeight': instance.maxHeight,
      'minHeight': instance.minHeight,
      'maxWidth': instance.maxWidth,
      'minWidth': instance.minWidth,
      'childAlignment': instance.childAlignment,
      'margin': instance.margin,
      'padding': instance.padding,
      'color': instance.color,
      'border': instance.border,
      'decorationImage': instance.decorationImage,
      'shape': instance.shape,
      'boxFit': instance.boxFit,
    };
