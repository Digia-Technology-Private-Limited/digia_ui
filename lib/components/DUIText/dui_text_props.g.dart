// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_text_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITextProps _$DUITextPropsFromJson(Map<String, dynamic> json) => DUITextProps()
  ..textSpans = (json['textSpans'] as List<dynamic>)
      .map((e) => DUITextSpan.fromJson(e as Map<String, dynamic>))
      .toList()
  ..fontSize = (json['fontSize'] as num?)?.toDouble()
  ..maxLines = json['maxLines'] as int?
  ..overFlow = json['overFlow'] == null
      ? null
      : DUITextOverFlow.fromJson(json['overFlow'] as Map<String, dynamic>)
  ..textScaleFactor = (json['textScaleFactor'] as num?)?.toDouble()
  ..alignment = json['alignment'] == null
      ? null
      : DUITextAlignment.fromJson(json['alignment'] as Map<String, dynamic>)
  ..fontWeight = json['fontWeight'] == null
      ? null
      : DUIFontWeight.fromJson(json['fontWeight'] as Map<String, dynamic>)
  ..color = json['color'] as String?
  ..isItalic = json['isItalic'] as bool?;

Map<String, dynamic> _$DUITextPropsToJson(DUITextProps instance) =>
    <String, dynamic>{
      'textSpans': instance.textSpans,
      'fontSize': instance.fontSize,
      'maxLines': instance.maxLines,
      'overFlow': instance.overFlow,
      'textScaleFactor': instance.textScaleFactor,
      'alignment': instance.alignment,
      'fontWeight': instance.fontWeight,
      'color': instance.color,
      'isItalic': instance.isItalic,
    };
