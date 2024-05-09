import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:flutter/material.dart';

const Map<String, String> defaultHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

class RestHandler {
  factory RestHandler() {
    return _instance;
  }

  static final RestHandler _instance = RestHandler._internal();

  RestHandler._internal();

  Future<dynamic>? executeAction(BuildContext context, ActionProp action) async {
    if (action.type != 'Action.restCall' || action.data.isEmpty) {
      return null;
    }

    // switch (action.data['method']) {
    //   case 'POST':
    //     return _post(action.data);
    // }

    return null;
  }

  // Future<dynamic>? _post(Map<String, dynamic> data) async {
  //   final url = Uri.parse(data['url']);
  //   final resp = await http
  //       .post(url,
  //           headers: _createHeaders(data['headers'] ?? {}),
  //           body: _createBody(data['body']))
  //       .timeout(const Duration(seconds: 10));
  //   final json = await jsonDecode(resp.body) as Map<String, dynamic>;

  //   if (data['keyToReadFrom'] == null) {
  //     return json;
  //   }
  //   return json.valueFor(keyPath: data['keyToReadFrom']);
  // }

  // Object? _createBody(Map<String, dynamic>? body) {
  //   if (body == null) return null;

  //   return jsonEncode(_fill(body));
  // }

  // Map<String, String> _createHeaders(Map<String, String> headers) {
  //   final defaultHeadersFromConfig =
  //       DigiaUIConfigResolver().getDefaultHeaders() ?? {};

  //   final mergedHeaders = {
  //     ...defaultHeaders,
  //     ..._fill(defaultHeadersFromConfig),
  //     ..._fill(headers)
  //   };

  //   return Map.fromEntries(mergedHeaders.entries
  //       .where((element) => element.value != null || element.value is! String)
  //       .map((e) => MapEntry(e.key, e.value as String)));
  // }

// TODO: MOve to a better location
  // Map<String, dynamic> _fill(Map<String, dynamic> body) {
  //   Map<String, dynamic> result = {};
  //   for (var MapEntry(:key, :value) in body.entries) {
  //     final variable = extractVar(value);
  //     result[key] = variable != null ? getValueIfVar(variable) : value;
  //   }
  //   return result;
  // }
}
