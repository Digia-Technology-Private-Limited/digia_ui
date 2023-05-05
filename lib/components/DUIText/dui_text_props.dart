import 'dart:convert';

import 'package:digia_ui/components/DUIText/DUI_text_span/dui_text_span.dart';
import 'package:digia_ui/components/DUIText/Dui_font_weight/dui_font_weight.dart';
import 'package:digia_ui/components/DUIText/Dui_text_alignment/dui_text_alignment.dart';
import 'package:digia_ui/components/DUIText/Dui_text_over_flow/dui_text_over_flow.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_text_props.g.dart';

@JsonSerializable()
class DUITextProps {
  late List<DUITextSpan> textSpans;
  late double? fontSize;
  late int? maxLines;
  late DUITextOverFlow? overFlow;
  late double? textScaleFactor;
  late DUITextAlignment? alignment;
  late DUIFontWeight? fontWeight;
  late String? color;
  late bool? isItalic;

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
        "fontSize": 18.0,
        "textSpans": [
          {
            "text": "Hello ",
            "fontSize": 36.0,
            "fontWeight": {"fontWeight": 800}
          },
          {
            "text": "prem ",
            "fontWeight": {"fontWeight": 300},
            "color": "2196F3",
            "fontSize": 12,
          },
        ],
      },
    );
  }
}
