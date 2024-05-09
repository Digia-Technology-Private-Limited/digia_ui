import 'package:json_annotation/json_annotation.dart';
part 'dui_htmview_props.g.dart';

@JsonSerializable()
class DUIHtmlViewProps {
  String content;

  DUIHtmlViewProps(this.content);

  factory DUIHtmlViewProps.fromJson(dynamic json) => _$DUIHtmlViewPropsFromJson(json);
  Map<String, dynamic> toJson() => _$DUIHtmlViewPropsToJson(this);
}
