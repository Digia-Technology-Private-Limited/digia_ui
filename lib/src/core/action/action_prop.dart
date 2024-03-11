import 'package:json_annotation/json_annotation.dart';

part 'action_prop.g.dart';

@JsonSerializable()
class ActionProp {
  final String type;
  final Map<String, dynamic> data;
  final bool inkwell;

  const ActionProp({
    required this.type,
    required this.data,
    this.inkwell = true,
  });

  factory ActionProp.fromJson(Map<String, dynamic> json) =>
      _$ActionPropFromJson(json);

  Map<String, dynamic> toJson() => _$ActionPropToJson(this);
}
