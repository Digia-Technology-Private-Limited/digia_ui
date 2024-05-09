// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_text_span.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITextSpan _$DUITextSpanFromJson(Map<String, dynamic> json) => DUITextSpan(
      text: json['text'],
      spanStyle: DUITextStyle.fromJson(json['spanStyle']),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$DUITextSpanToJson(DUITextSpan instance) =>
    <String, dynamic>{
      'text': instance.text,
      'url': instance.url,
    };
