import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'dui_text_span.g.dart';

@JsonSerializable()
class DUITextSpan {
  late String text;
  String? spanStyle;
  String? url;

  DUITextSpan();

  factory DUITextSpan.fromJson(Map<String, dynamic> json) =>
      _$DUITextSpanFromJson(json);

  Map<String, dynamic> toJson() => _$DUITextSpanToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
