// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_text_field_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITextFieldProps _$DUITextFieldPropsFromJson(Map<String, dynamic> json) => DUITextFieldProps()
  ..textStyle = json['textStyle'] as String
  ..label = DUITextProps.fromJson(json['label'])
  ..border = json['border'] == null ? null : DUIBorder.fromJson(json['border'])
  ..focusedBorder = json['focusedBorder'] == null ? null : DUIBorder.fromJson(json['focusedBorder'])
  ..hintText = json['hintText'] as String?
  ..hintTextStyle = json['hintTextStyle'] as String?
  ..inputType = json['inputType'] as String?
  ..dataKey = json['dataKey'] as String;

Map<String, dynamic> _$DUITextFieldPropsToJson(DUITextFieldProps instance) => <String, dynamic>{
      'textStyle': instance.textStyle,
      'label': instance.label,
      'border': instance.border,
      'focusedBorder': instance.focusedBorder,
      'hintText': instance.hintText,
      'hintTextStyle': instance.hintTextStyle,
      'inputType': instance.inputType,
      'dataKey': instance.dataKey,
    };
