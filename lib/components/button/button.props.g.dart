// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIButtonProps _$DUIButtonPropsFromJson(Map<String, dynamic> json) =>
    DUIButtonProps()
      ..width = (json['width'] as num).toDouble()
      ..height = (json['height'] as num).toDouble()
      ..margin = json['margin'] == null
          ? null
          : DUIInsets.fromJson(json['margin'] as Map<String, dynamic>)
      ..padding = json['padding'] == null
          ? null
          : DUIInsets.fromJson(json['padding'] as Map<String, dynamic>)
      ..cornerRadius = json['cornerRadius'] == null
          ? null
          : DUICornerRadius.fromJson(
              json['cornerRadius'] as Map<String, dynamic>)
      ..text = json['text'] as String
      ..textColor = json['textColor'] as String?
      ..disabledTextColor = json['disabledTextColor'] as String?
      ..backgroundColor = json['backgroundColor'] as String?
      ..disabledBackgroundColor = json['disabledBackgroundColor'] as String?
      ..disabled = json['disabled'] as bool?
      ..fontSize = (json['fontSize'] as num?)?.toDouble();

Map<String, dynamic> _$DUIButtonPropsToJson(DUIButtonProps instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'margin': instance.margin,
      'padding': instance.padding,
      'cornerRadius': instance.cornerRadius,
      'text': instance.text,
      'textColor': instance.textColor,
      'disabledTextColor': instance.disabledTextColor,
      'backgroundColor': instance.backgroundColor,
      'disabledBackgroundColor': instance.disabledBackgroundColor,
      'disabled': instance.disabled,
      'fontSize': instance.fontSize,
    };
