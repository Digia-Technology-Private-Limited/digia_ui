import '../../utils/functional_util.dart';
import '../../utils/num_util.dart';
import '../../utils/types.dart';
import '../action_factory.dart';
import 'action.dart';

class ActionFlow {
  final List<Action> actions;
  final bool inkwell;
  final List<JsonLike>? analyticsData;

  ActionFlow({
    required this.actions,
    this.inkwell = true,
    this.analyticsData,
  });

  factory ActionFlow.empty() => ActionFlow(actions: []);

  static ActionFlow? fromJson(Object? json) {
    if (json is! JsonLike) return null;

    final inkwell = NumUtil.toBool(json['inkwell']) ?? true;

    final actions = as$<List>(json['steps'])
            ?.where((e) => e != null)
            .map((e) => ActionFactory.fromJson(e))
            .toList() ??
        [];

    final analyticsData =
        as$<List>(json['analyticsData'])?.nonNulls.cast<JsonLike>().toList() ??
            [];

    // It's possible that events need to be sent, regardless of
    // whether actions are present or not.
    if (analyticsData.isEmpty && actions.isEmpty) return null;

    return ActionFlow(
      actions: actions,
      inkwell: inkwell,
      analyticsData: analyticsData,
    );
  }

  Map<String, dynamic> toJson() => {'actions': actions.map((e) => e.toJson())};
}
