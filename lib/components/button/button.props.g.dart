// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIButtonProps _$DUIButtonPropsFromJson(Map<String, dynamic> json) =>
    DUIButtonProps()
      ..width = (json['width'] as num).toDouble()
      ..height = (json['height'] as num).toDouble()
      ..text = json['text'] as String
      ..textColor = json['textColor'] as String
      ..disabledTextColor = json['disabledTextColor'] as String
      ..backgroundColor = json['backgroundColor'] as String
      ..disabledBackgroundColor = json['disabledBackgroundColor'] as String
      ..disabled = json['disabled'] as bool;

Map<String, dynamic> _$DUIButtonPropsToJson(DUIButtonProps instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'text': instance.text,
      'textColor': instance.textColor,
      'disabledTextColor': instance.disabledTextColor,
      'backgroundColor': instance.backgroundColor,
      'disabledBackgroundColor': instance.disabledBackgroundColor,
      'disabled': instance.disabled,
    };
