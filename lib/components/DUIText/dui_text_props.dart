import 'dart:convert';

import 'package:digia_ui/components/DUIText/DUI_text_span/dui_text_span.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_text_props.g.dart';

@JsonSerializable()
class DUITextProps {
  late List<DUITextSpan> textSpans;
  late int? maxLines;
  late String? overflow;
  late String? alignment;
  late String? styleClass;

  DUITextProps();

  factory DUITextProps.withText(String text) =>
      DUITextProps()..textSpans = [DUITextSpan()..text = text];

  factory DUITextProps.fromJson(Map<String, dynamic> json) =>
      _$DUITextPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUITextPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  DUITextProps mockWidget() {
    return DUITextProps.fromJson(
      {
        "styleClass": "f:heading1Loose;tc:accent5",
        "maxLines": 2,
        "textSpans": [
          {
            "text": "Hello ",
          },
          {
            "text": "prem ",
            "styleClass": "f:para1;tc:accent6;dc:underline",
            'url': 'https://google.com',
          },
        ],
      },
    );
  }
}
