import 'dart:convert';

import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/core/action/action_prop.dart';

const Map<String, String> defaultHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

class PostAction {
  final DUIConfig resolver;

  PostAction(this.resolver);

  Future<Map<String, dynamic>?> execute(ActionProp action) async {
    // TODO: Remove Singleton Access @tushar-g
    final resp = await DigiaUIClient.getNetworkClient()
        .post(path: '/action/postAction', fromJsonT: (json) => json as dynamic, data: jsonEncode(action.toJson()));
    return resp.data;
  }
}
