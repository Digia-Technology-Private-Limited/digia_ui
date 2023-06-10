import 'dart:convert';

import 'package:digia_ui/components/DUIText/DUI_text_span/dui_text_span.dart';

part 'dui_text_props.json.dart';

class DUITextProps {
  late List<DUITextSpan> textSpans;
  late int? maxLines;
  late String? overflow;
  late String? alignment;
  late String? styleClass;

  DUITextProps();

  factory DUITextProps.withText(
      {required String text,
      String? styleClass,
      int? maxLines,
      String? overflow,
      String? alignment}) {
    return DUITextProps()
      ..textSpans = [DUITextSpan()..text = text]
      ..styleClass = styleClass
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
