import 'dart:convert';

import '../../Utils/basic_shared_utils/num_decoder.dart';
import 'DUI_text_span/dui_text_span.dart';
import 'dui_text_style.dart';

part 'dui_text_props.json.dart';

class DUITextProps {
  List<DUITextSpan>? textSpans;
  int? maxLines;
  String? overflow;
  String? alignment;
  DUITextStyle? textStyle;

  DUITextProps(
      {this.textStyle,
      this.alignment,
      this.maxLines,
      this.overflow,
      this.textSpans});

  factory DUITextProps.withText(
      {required dynamic text,
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

  DUITextProps copyWith(
      {int? maxLines,
      String? overflow,
      String? alignment,
      DUITextStyle? textStyle,
      List<DUITextSpan>? textSpans}) {
    return DUITextProps(
      textSpans: textSpans ?? this.textSpans,
      alignment: alignment ?? this.alignment,
      textStyle: textStyle ?? this.textStyle,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
    );
  }
}
