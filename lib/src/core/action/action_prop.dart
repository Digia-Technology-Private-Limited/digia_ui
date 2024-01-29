import 'package:json_annotation/json_annotation.dart';

part 'action_prop.g.dart';

@JsonSerializable()
class ActionProp {
  String type;
  Map<String, dynamic> data;

  ActionProp({required this.type, required this.data});

  factory ActionProp.fromJson(Map<String, dynamic> json) =>
      _$ActionPropFromJson(json);

  Map<String, dynamic> toJson() => _$ActionPropToJson(this);
}
