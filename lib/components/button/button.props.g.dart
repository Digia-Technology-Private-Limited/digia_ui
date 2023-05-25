// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIButtonProps _$DUIButtonPropsFromJson(Map<String, dynamic> json) =>
    DUIButtonProps()
      ..styleClass = DUIStyleClass.fromJson(json['styleClass'])
      ..text = DUITextProps.fromJson(json['text'] as Map<String, dynamic>)
      ..disabledBackgroundColor = json['disabledBackgroundColor'] as String?
      ..disabled = json['disabled'] as bool?;

Map<String, dynamic> _$DUIButtonPropsToJson(DUIButtonProps instance) =>
    <String, dynamic>{
      'text': instance.text,
      'disabledBackgroundColor': instance.disabledBackgroundColor,
      'disabled': instance.disabled,
    };
