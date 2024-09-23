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

  factory ActionFlow.fromJson(dynamic json) {
    if (json is! JsonLike) return ActionFlow.empty();

    final inkwell = NumUtil.toBool(json['inkwell']) ?? true;

    return ActionFlow(
      actions: as$<List>(json['steps'])
              ?.where((e) => e != null)
              .map((e) => ActionFactory.fromJson(e))
              .toList() ??
          [],
      inkwell: inkwell,
      analyticsData: as$<List>(json['analyticsData'])?.cast<JsonLike>(),
    );
  }

  Map<String, dynamic> toJson() => {'actions': actions.map((e) => e.toJson())};
}
