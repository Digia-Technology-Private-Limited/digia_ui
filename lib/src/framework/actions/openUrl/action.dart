import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../base/action.dart';

class OpenUrlAction extends Action {
  final ExprOr<String>? url;
  final String? launchMode;

  OpenUrlAction({
    required this.url,
    required this.launchMode,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.openUrl;

  @override
  Map<String, dynamic> toJson() => {
        'type': actionType.toString(),
        'url': url?.toJson(),
        'launchMode': launchMode,
      };

  factory OpenUrlAction.fromJson(Map<String, Object?> json) {
    return OpenUrlAction(
      url: ExprOr.fromJson<String>(json['url']),
      launchMode: as$<String>(json['launchMode']),
    );
  }
}
