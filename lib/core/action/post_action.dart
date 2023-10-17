import 'dart:convert';

import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/core/action/action_prop.dart';
import 'package:digia_ui/network/core/types.dart';
import 'package:digia_ui/project_constants.dart';

import '../../network/network_manager.dart';

const Map<String, String> defaultHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

class PostAction {
  final ConfigResolver resolver;

  PostAction(this.resolver);

  Future<Map<String, dynamic>?> execute(ActionProp action) async {
    final baseUrl = resolver.baseUrl ?? ProjectConstants.baseUrl;

    final resp = await NetworkManager().request(HttpMethod.post,
        '$baseUrl/action/postAction', (json) => json as dynamic,
        data: jsonEncode(action.toJson()));

    return resp.data;
  }
}
