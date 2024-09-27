import '../../models/types.dart';
import '../../utils/json_util.dart';
import '../base/action.dart';

class PostMessageAction extends Action {
  final String name;
  final ExprOr<Object>? payload;

  PostMessageAction({
    required this.name,
    required this.payload,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.postMessage;

  @override
  Map<String, dynamic> toJson() => {
        'type': actionType.toString(),
        'name': name,
        'payload': payload?.toJson(),
      };

  factory PostMessageAction.fromJson(Map<String, Object?> json) {
    return PostMessageAction(
        name: json['name'] as String,
        payload: tryKeys(json, ['body', 'payload'],
            parse: (p0) => ExprOr.fromJson<Object>(p0)));
  }
}
