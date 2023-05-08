import 'dart:convert';

import 'package:digia_ui/components/DUIText/DUI_text_span/dui_text_span.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_text_props.g.dart';

@JsonSerializable()
class DUITextProps {
  late List<DUITextSpan> textSpans;
  late int? maxLines;
  late String? overFlow;
  late String? alignment;
  late String style;

  DUITextProps();

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
        "style": "f:heading1Loose;tc:text",
        "maxLines": 2,
        "textSpans": [
          {
            "text": "Hello ",
          },
          {
            "text": "prem ",
            "style": "f:para1;tc:accent6;dc:underline",
            'url': 'https://google.com',
          },
        ],
      },
    );
  }
}
