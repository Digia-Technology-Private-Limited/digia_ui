import 'package:digia_ui/src/components/DUIText/dui_text_style.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_text_span.g.dart';

@JsonSerializable()
class DUITextSpan {
  dynamic text;
  @JsonKey(fromJson: DUITextStyle.fromJson, includeToJson: false)
  DUITextStyle? spanStyle;
  String? url;

  DUITextSpan();

  factory DUITextSpan.fromJson(Map<String, dynamic> json) =>
      _$DUITextSpanFromJson(json);

  Map<String, dynamic> toJson() => _$DUITextSpanToJson(this);
}
