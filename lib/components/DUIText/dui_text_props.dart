import 'dart:convert';

import 'package:digia_ui/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/components/DUIText/DUI_text_span/dui_text_span.dart';
import 'package:digia_ui/components/DUIText/dui_text_style.dart';

part 'dui_text_props.json.dart';

class DUITextProps {
  late List<DUITextSpan> textSpans;
  late int? maxLines;
  late String? overflow;
  late String? alignment;
  late DUITextStyle? textStyle;

  DUITextProps();

  factory DUITextProps.withText(
      {required String text,
      DUITextStyle? textStyle,
      int? maxLines,
      String? overflow,
      String? alignment}) {
    return DUITextProps()
      ..textSpans = [DUITextSpan()..text = text]
      ..textStyle = textStyle
      ..alignment = alignment
      ..overflow = overflow
      ..maxLines = maxLines;
  }

  factory DUITextProps.fromJson(dynamic json) => _$DUITextPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUITextPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
