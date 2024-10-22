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
          actions: [ActionProp.fromJson(json as Map<String, dynamic>)],
          inkwell: inkwell,
          analyticsData: json['analyticsData'] as List<Map<String, dynamic>>?);
    }

    if (json['steps'] is List) {
      final List<ActionProp> steps = json['steps']
          .where((Map<String, dynamic>? e) => e != null)
          .map((Map<String, dynamic> e) => ActionProp.fromJson(e))
          .cast<ActionProp>()
          .toList() as List<ActionProp>;
      final analyticsDataJson = (json['analyticsData'] as List?);

      final ad = analyticsDataJson
          ?.where((e) => e != null)
          .cast<Map<String, dynamic>>()
          .toList();
      return ActionFlow(
        actions: steps,
        inkwell: inkwell,
        analyticsData: ad,
      );
    }

    return ActionFlow.empty();
  }

  Map<String, dynamic> toJson() => {'actions': actions.map((e) => e.toJson())};

  static bool _isActionProp(dynamic json) =>
      json is Map && json['type'] != null;
}

@JsonSerializable()
class ActionProp {
  final String type;
  final Map<String, dynamic> data;
  final dynamic disableActionIf;

  const ActionProp(
      {required this.type, this.data = const {}, this.disableActionIf});

  factory ActionProp.fromJson(Map<String, dynamic> json) =>
      _$ActionPropFromJson(json);

  Map<String, dynamic> toJson() => _$ActionPropToJson(this);
}
