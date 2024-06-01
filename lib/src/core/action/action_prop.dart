import 'package:json_annotation/json_annotation.dart';

import '../../Utils/basic_shared_utils/num_decoder.dart';

part 'action_prop.g.dart';

class ActionFlow {
  final List<ActionProp> actions;
  final bool inkwell;
  final List<Map<String, dynamic>>? analyticsData;

  ActionFlow({required this.actions, this.inkwell = true, this.analyticsData});

  factory ActionFlow.empty() => ActionFlow(actions: []);

  factory ActionFlow.fromJson(dynamic json) {
    if (json == null) return ActionFlow.empty();

    final inkwell =
        NumDecoder.toBoolOrDefault(json['inkwell'], defaultValue: true);

    // Backward compatibility
    if (_isActionProp(json)) {
      return ActionFlow(
          actions: [ActionProp.fromJson(json)],
          inkwell: inkwell,
          analyticsData: json['analyticsData']);
    }

    if (json['steps'] is List) {
      return ActionFlow(
        actions: json['steps']
            .where((e) => e != null)
            .map((e) => ActionProp.fromJson(e))
            .cast<ActionProp>()
            .toList(),
        inkwell: inkwell,
        analyticsData: (json['analyticsData'] as List<Map<String, dynamic>?>?)
            ?.nonNulls
            .toList(),
      );
    }

    return ActionFlow.empty();
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

  factory ActionProp.fromJson(Map<String, dynamic> json) =>
      _$ActionPropFromJson(json);

  Map<String, dynamic> toJson() => _$ActionPropToJson(this);
}
