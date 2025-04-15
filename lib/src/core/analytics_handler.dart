import 'package:flutter/material.dart';

import '../../digia_ui.dart';
import '../framework/expr/expression_util.dart';
import '../framework/expr/scope_context.dart';
import '../framework/utils/functional_util.dart';

class AnalyticsHandler {
  static final AnalyticsHandler _instance = AnalyticsHandler._();

  AnalyticsHandler._();

  static AnalyticsHandler get instance => _instance;

  Future<dynamic>? execute(
      {required BuildContext context,
      required List<Map<String, dynamic>>? events,
      ScopeContext? enclosing}) async {
    if (events == null) return;
    final DUILogger? logger = DigiaUIClient.instance.developerConfig?.logger;

    _logAnalytics(logger, events, context, enclosing);

    final data = evaluateNestedExpressions(events, enclosing);

    if (data is! List || data.isEmpty) return;

    final analyticEvents = data
        .where((e) => e != null && e is Map<String, dynamic>)
        .map((e) => AnalyticEvent.fromJson(as<Map<String, dynamic>>(e)))
        .toList();

    if (analyticEvents.isNotEmpty) {
      DigiaUIClient.instance.duiAnalytics?.onEvent(analyticEvents);
    }
  }
}

void _logAnalytics(DUILogger? logger, List<Map<String, dynamic>>? events,
    BuildContext context, ScopeContext? enclosing) {
  if (events == null) return;

  for (var event in events) {
    String eventName = as$<String>(event['name']) ?? 'Unknown Event';
    Map<String, dynamic> eventPayload = as<Map<String, dynamic>>(
        evaluateNestedExpressions(event['payload'] ?? {}, enclosing));
    logger?.logEvent(eventName: eventName, eventPayload: eventPayload);
  }
}
