import 'package:flutter/material.dart';

import '../../digia_ui.dart';
import '../framework/expr/expression_util.dart';
import '../framework/expr/scope_context.dart';
import '../framework/utils/functional_util.dart';

class AnalyticsHandler {
  static final AnalyticsHandler _instance = AnalyticsHandler._();

  AnalyticsHandler._();

  static AnalyticsHandler get instance => _instance;

  Future<void> execute({
    required BuildContext context,
    required List<AnalyticEvent> events,
    ScopeContext? enclosing,
  }) async {
    final logger = DigiaUIClient.instance.developerConfig?.logger;

    _logAnalytics(logger, events, context, enclosing);

    final evaluatedList = events.map((event) {
      final payload = as$<Map<String, dynamic>>(
          evaluateNestedExpressions(event.payload, enclosing));
      return AnalyticEvent(name: event.name, payload: payload);
    }).toList();

    DigiaUIClient.instance.duiAnalytics?.onEvent(evaluatedList);
  }
}

void _logAnalytics(DUILogger? logger, List<AnalyticEvent>? events,
    BuildContext context, ScopeContext? enclosing) {
  if (events == null) return;

  for (var event in events) {
    String eventName = as$<String>(event.name) ?? 'Unknown Event';
    Map<String, dynamic> eventPayload = as<Map<String, dynamic>>(
        evaluateNestedExpressions(event.payload ?? {}, enclosing));
    logger?.logEvent(eventName: eventName, eventPayload: eventPayload);
  }
}
