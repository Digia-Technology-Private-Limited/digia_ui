import 'package:json_annotation/json_annotation.dart';
part 'dui_htmview_props.g.dart';

@JsonSerializable()
class DUIHTMLViewProps {
  String content;

  DUIHTMLViewProps(this.content);

  factory DUIHTMLViewProps.fromJson(dynamic json) =>
      _$DUIHTMLViewPropsFromJson(json);
  Map<String, dynamic> toJson() => _$DUIHTMLViewPropsToJson(this);
}
