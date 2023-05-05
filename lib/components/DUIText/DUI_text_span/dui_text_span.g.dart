// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_text_span.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITextSpan _$DUITextSpanFromJson(Map<String, dynamic> json) => DUITextSpan()
  ..text = json['text'] as String
  ..fontWeight = json['fontWeight'] == null
      ? null
      : DUIFontWeight.fromJson(json['fontWeight'] as Map<String, dynamic>)
  ..color = json['color'] as String?
  ..fontSize = (json['fontSize'] as num?)?.toDouble()
  ..isUnderlined = json['isUnderlined'] as bool?
  ..isItalic = json['isItalic'] as bool?
  ..url = json['url'] as String?;

Map<String, dynamic> _$DUITextSpanToJson(DUITextSpan instance) =>
    <String, dynamic>{
      'text': instance.text,
      'fontWeight': instance.fontWeight,
      'color': instance.color,
      'fontSize': instance.fontSize,
      'isUnderlined': instance.isUnderlined,
      'isItalic': instance.isItalic,
      'url': instance.url,
    };
