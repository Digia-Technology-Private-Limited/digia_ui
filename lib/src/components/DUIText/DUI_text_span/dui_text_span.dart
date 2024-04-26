import 'package:json_annotation/json_annotation.dart';

import '../dui_text_style.dart';

part 'dui_text_span.g.dart';

@JsonSerializable()
class DUITextSpan {
  dynamic text;
  @JsonKey(fromJson: DUITextStyle.fromJson, includeToJson: false)
  DUITextStyle? spanStyle;
  String? url;

  DUITextSpan({this.text, this.spanStyle, this.url});

  factory DUITextSpan.fromJson(Map<String, dynamic> json) =>
      _$DUITextSpanFromJson(json);

  Map<String, dynamic> toJson() => _$DUITextSpanToJson(this);
}
