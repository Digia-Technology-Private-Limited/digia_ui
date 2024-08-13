import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../digia_ui.dart';
import '../Utils/expr.dart';
import '../dui_logger.dart';

class AnalyticsHandler {
  static final AnalyticsHandler _instance = AnalyticsHandler._();

  AnalyticsHandler._();

  static AnalyticsHandler get instance => _instance;

  Future<dynamic>? execute(
      {required BuildContext context,
      required List<Map<String, dynamic>>? events,
      ExprContext? enclosing}) async {
    if (events == null) return;
    final DUILogger? logger = DigiaUIClient.instance.developerConfig?.logger;

    _logAnalytics(logger, events, context, enclosing);

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

void _logAnalytics(DUILogger? logger, List<Map<String, dynamic>>? events,
    BuildContext context, ExprContext? enclosing) {
  if (events == null) return;

  for (var event in events) {
    String eventName = event['name'] ?? 'Unknown Event';
    Map<String, dynamic> eventPayload =
        evalDynamic(event['payload'] ?? {}, context, enclosing);
    logger?.log(EventLog(eventName, eventPayload));
  }
}
