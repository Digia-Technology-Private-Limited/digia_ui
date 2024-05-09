import 'package:json_annotation/json_annotation.dart';

part 'dui_stack_props.g.dart';

@JsonSerializable()
class DUIStackProps {
  final String? fit;
  final String? childAlignment;

  DUIStackProps({
    this.fit,
    this.childAlignment,
  });

  factory DUIStackProps.fromJson(Map<String, dynamic> json) =>
      _$DUIStackPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIStackPropsToJson(this);
}
