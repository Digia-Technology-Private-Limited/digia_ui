part of 'dui_text_props.dart';

// ignore: slash_for_doc_comments
/**
      1) With Text Spans (Every span may have different style)
      {
        "styleClass": "f:h1;tc:accent1",
        "maxLines": 2,
        "overflow": "ellipsis",
        "textSpans": [
          {
            "text": "Hello ",
          },
          {
            "text": "World",
            "styleClass": "f:para1;tc:accent6;dc:underline",
          },
        ],
      }

      2) With Text and single style
      {
        "styleClass": "f:h1;tc:accent1",
        "maxLines": 2,
        "overflow": "ellipsis",
        "text": "Hello World"
      }

      3) Plain String is also supported
      "Hello World"
 */

DUITextProps _$DUITextPropsFromJson(dynamic json) {
  if (json is String) {
    return DUITextProps.withText(text: json);
  }

  var text = json['text'] as String?;
  var textSpans = (json['textSpans'] as List<dynamic>?)
      ?.map((e) => DUITextSpan.fromJson(e as Map<String, dynamic>))
      .toList();

  return DUITextProps()
    ..alignment = json['alignment'] as String?
    ..styleClass = json['styleClass'] as String?
    ..overflow = json['overflow'] as String?
    ..maxLines = json['maxLines'] as int?
    ..textSpans =
        textSpans ?? ((text != null) ? [DUITextSpan()..text = text] : []);
}

Map<String, dynamic> _$DUITextPropsToJson(DUITextProps instance) =>
    <String, dynamic>{
      'textSpans': instance.textSpans,
      'maxLines': instance.maxLines,
      'overflow': instance.overflow,
      'alignment': instance.alignment,
      'styleClass': instance.styleClass,
    };
