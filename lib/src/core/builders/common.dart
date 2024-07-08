import 'dart:convert';

import 'package:flutter/material.dart';

import '../evaluator.dart';
import '../page/props/dui_widget_json_data.dart';

List<Object> createDataItemsForDynamicChildren(
    {required DUIWidgetJsonData data, required BuildContext context}) {
  if (data.dataRef.isEmpty) return [];
  if (data.dataRef['kind'] == 'json') {
    return _toList(data.dataRef['datum'])?.cast<Object>() ?? [];
  } else {
    return eval<List>(
          data.dataRef['datum'],
          context: context,
          decoder: (p0) => p0 as List?,
        )?.cast<Object>() ??
        [];
  }
}

List? _toList(dynamic data) {
  if (data is String) {
    try {
      final list = jsonDecode(data);
      if (list is! List) return null;
      return list;
    } catch (e) {
      return null;
    }
  }

  return data as List?;
}
