import 'package:json_annotation/json_annotation.dart';

part 'action_prop.g.dart';

@JsonSerializable()
class ActionFlow {
  final List<ActionProp> actions;

  ActionFlow({required this.actions});

  factory ActionFlow.fromJson(dynamic json) {
    try {
      if (ActionProp.isActionProp(json)) {
        ActionFlow(actions: [ActionProp.fromJson(json)]);
      }

      if (json is List) {
        ActionFlow(actions: json.map((e) => ActionProp.fromJson(e)).toList());
      }

      return ActionFlow(actions: []);
    } catch (err) {
      return ActionFlow(actions: []);
    }
  }

  Map<String, dynamic> toJson() => {'actions': actions.map((e) => e.toJson())};
}

@JsonSerializable()
class ActionProp {
  final String type;
  final Map<String, dynamic> data;
  final bool inkwell;

  static isActionProp(dynamic json) => json is Map && json['type'] != null;

  const ActionProp({
    required this.type,
    required this.data,
    this.inkwell = true,
  });

  factory ActionProp.fromJson(Map<String, dynamic> json) =>
      _$ActionPropFromJson(json);

  Map<String, dynamic> toJson() => _$ActionPropToJson(this);
}
