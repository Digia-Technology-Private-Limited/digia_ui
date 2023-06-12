import 'dart:convert';

import 'package:digia_ui/Utils/extensions.dart';
import 'package:digia_ui/core/action/action_prop.dart';
import 'package:digia_ui/core/pref/pref_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<dynamic>? executeAction(
      BuildContext context, ActionProp action) async {
    if (action.type != 'rest_call' || action.data.isEmpty) {
      return null;
    }

    switch (action.data['method']) {
      case 'POST':
        return _post(action.data);
    }

    return null;
  }

// TODO: Figure out a better way to read data from a key
  Future<dynamic>? _post(Map<String, dynamic> data) async {
    final authToken = PrefUtil.getString('authToken');
    final url = Uri.parse(data['url']);
    final resp = await http.post(url,
        headers: {...defaultHeaders, 'authorization': 'Bearer $authToken'},
        body: data['body'] != null ? jsonEncode(data['body']) : null);
    final json = await jsonDecode(resp.body) as Map<String, dynamic>;
    if (data['keyToReadFrom'] == null) {
      return json;
    }
    return json.valueFor(keyPath: data['keyToReadFrom']);
  }
}
