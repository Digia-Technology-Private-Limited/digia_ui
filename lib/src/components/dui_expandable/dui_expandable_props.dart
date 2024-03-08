import 'package:json_annotation/json_annotation.dart';

part 'dui_expandable_props.g.dart';

@JsonSerializable()
class DUIExpandableProps{
  final String? title;

  DUIExpandableProps(this.title);
}