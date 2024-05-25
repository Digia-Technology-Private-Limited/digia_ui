import 'package:json_annotation/json_annotation.dart';
import '../DUIText/dui_text_props.dart';

part 'dz_step.g.dart';

@JsonSerializable()
class DZStep {
  final DUITextProps? title;
  final DUITextProps? subtitle;
  final Map<String, dynamic>? stepIcon;

  DZStep({this.title, this.subtitle, this.stepIcon});

  factory DZStep.fromJson(Map<String, dynamic> json) => _$DZStepFromJson(json);

  Map<String, dynamic> toJson() => _$DZStepToJson(this);
}
