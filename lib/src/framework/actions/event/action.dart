import '../../../../digia_ui.dart';
import '../../utils/functional_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';

class FireEventAction extends Action {
  final List<AnalyticEvent> events;

  FireEventAction({required this.events});

  @override
  ActionType get actionType => ActionType.fireEvent;

  factory FireEventAction.fromJson(Map<String, Object?> json) {
    return FireEventAction(
        events: as$<List<dynamic>>(json['events'])
                ?.map((it) => as$<JsonLike>(it))
                .nonNulls
                .map(AnalyticEvent.fromJson)
                .toList() ??
            []);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': actionType.toString(),
      'events': events,
    };
  }
}
