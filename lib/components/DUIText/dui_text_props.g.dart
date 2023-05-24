// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_text_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITextProps _$DUITextPropsFromJson(Map<String, dynamic> json) => DUITextProps()
  ..textSpans = (json['textSpans'] as List<dynamic>)
      .map((e) => DUITextSpan.fromJson(e as Map<String, dynamic>))
      .toList()
  ..maxLines = json['maxLines'] as int?
  ..overflow = json['overflow'] as String?
  ..alignment = json['alignment'] as String?
  ..styleClass = json['styleClass'] as String?;

Map<String, dynamic> _$DUITextPropsToJson(DUITextProps instance) =>
    <String, dynamic>{
      'textSpans': instance.textSpans,
      'maxLines': instance.maxLines,
      'overflow': instance.overflow,
      'alignment': instance.alignment,
      'styleClass': instance.styleClass,
    };
