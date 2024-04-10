// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIButtonProps _$DUIButtonPropsFromJson(Map<String, dynamic> json) =>
    DUIButtonProps()
      ..styleClass = DUIStyleClass.fromJson(json['style'])
      ..text = DUITextProps.fromJson(json['text'])
      ..disabledBackgroundColor = json['disabledBackgroundColor'] as String?
      ..disabled = json['disabled'] as bool?
      ..onClick =
          json['onClick'] == null ? null : ActionFlow.fromJson(json['onClick'])
      ..setLoading = json['setLoading'] as bool?;

Map<String, dynamic> _$DUIButtonPropsToJson(DUIButtonProps instance) =>
    <String, dynamic>{
      'text': instance.text,
      'disabledBackgroundColor': instance.disabledBackgroundColor,
      'disabled': instance.disabled,
      'onClick': instance.onClick,
      'setLoading': instance.setLoading,
    };
