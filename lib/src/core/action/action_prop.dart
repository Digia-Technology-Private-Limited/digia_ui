import 'package:json_annotation/json_annotation.dart';

part 'action_prop.g.dart';

class ActionFlow {
  final List<ActionProp> actions;
  final bool inkwell;

  ActionFlow({required this.actions, this.inkwell = true});

  factory ActionFlow.fromJson(dynamic json) {
    final inkwell = json['inkwell'] as bool? ?? true;

    // Backward compatibility
    if (_isActionProp(json)) {
      return ActionFlow(actions: [ActionProp.fromJson(json)]);
    }

    if (json is List) {
      return ActionFlow(actions: json.map((e) => ActionProp.fromJson(e)).toList());
    }

    return ActionFlow(actions: [], inkwell: inkwell);
  }

  Map<String, dynamic> toJson() => {'actions': actions.map((e) => e.toJson())};

  static _isActionProp(dynamic json) => json is Map && json['type'] != null;
}

@JsonSerializable()
class ActionProp {
  final String type;
  final Map<String, dynamic> data;

  const ActionProp({
    required this.type,
    this.data = const {},
  });

  factory ActionProp.fromJson(Map<String, dynamic> json) => _$ActionPropFromJson(json);

  Map<String, dynamic> toJson() => _$ActionPropToJson(this);
}
