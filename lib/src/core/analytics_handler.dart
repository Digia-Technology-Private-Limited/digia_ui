import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../digia_ui.dart';
import '../Utils/expr.dart';

class AnalyticsHandler {
  static final AnalyticsHandler _instance = AnalyticsHandler._();

  AnalyticsHandler._();

  static AnalyticsHandler get instance => _instance;

  Future<dynamic>? execute(
      {required BuildContext context,
      required List<Map<String, dynamic>>? events,
      ExprContext? enclosing}) async {
    if (events == null) return;

    final data = evalDynamic(events, context, enclosing);

    if (data is! List || data.isEmpty) return;

    final analyticEvents = data
        .where((e) => e != null && e is Map<String, dynamic>)
        .map((e) => AnalyticEvent.fromJson(e))
        .toList();

    if (analyticEvents.isNotEmpty) {
      DigiaUIClient.instance.duiAnalytics?.onEvent(analyticEvents);
    }
  }
}
