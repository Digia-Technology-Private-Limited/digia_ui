import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../digia_ui.dart';
import '../Utils/expr.dart';

typedef AnalyticsEvent = Map<String, dynamic>;

class AnalyticsHandler {
  static final AnalyticsHandler _instance = AnalyticsHandler._();

  AnalyticsHandler._();

  static AnalyticsHandler get instance => _instance;

  Future<dynamic>? execute(
      {required BuildContext context,
      required List<AnalyticsEvent>? events,
      ExprContext? enclosing}) async {
    final data =
        evalDynamic(events, context, enclosing) as List<AnalyticsEvent>?;

    if (data != null && data.isNotEmpty) {
      DigiaUIClient.instance.duiAnalytics?.onEvent(data);
    }
  }
}
