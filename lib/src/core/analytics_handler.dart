import 'package:flutter/material.dart';

import '../../digia_ui.dart';
import '../Utils/extensions.dart';
import '../framework/expr/expression_util.dart';
import '../framework/expr/scope_context.dart';
import '../framework/utils/functional_util.dart';

/// Singleton class responsible for processing and executing analytics events within the Digia UI system.
///
/// [AnalyticsHandler] serves as the central point for handling analytics events that contain
/// dynamic expressions. It evaluates these expressions using the provided scope context
/// and forwards the processed events to registered analytics providers.
///
/// Key responsibilities:
/// - Processing analytics events with expression evaluation
/// - Integrating with external analytics providers
/// - Logging events for debugging purposes
/// - Managing analytics scope and context
///
/// The handler supports dynamic expressions in analytics payloads, allowing events to include
/// data from app state, page arguments, user inputs, and other contextual information.
///
/// Example usage:
/// ```dart
/// await AnalyticsHandler.instance.execute(
///   context: context,
///   events: [
///     AnalyticEvent(
///       name: 'user_action',
///       payload: {
///         'action': 'button_click',
///         'userId': '${appState.currentUser.id}',
///         'timestamp': '${now()}',
///       },
///     ),
///   ],
///   enclosing: scopeContext,
/// );
/// ```
class AnalyticsHandler {
  /// Singleton instance of the analytics handler
  static final AnalyticsHandler _instance = AnalyticsHandler._();

  /// Private constructor for singleton pattern
  AnalyticsHandler._();

  /// Returns the singleton instance of AnalyticsHandler
  static AnalyticsHandler get instance => _instance;

  /// Executes a list of analytics events with expression evaluation and provider integration.
  ///
  /// This method processes analytics events by:
  /// 1. Evaluating dynamic expressions in event payloads using the provided scope
  /// 2. Logging events to the Digia UI logging system for debugging
  /// 3. Forwarding processed events to the registered analytics handler in the widget tree
  ///
  /// Parameters:
  /// - [context]: BuildContext used to access the analytics handler from widget tree
  /// - [events]: List of analytics events to process and execute
  /// - [enclosing]: Optional scope context for expression evaluation, provides access
  ///   to variables like app state, page args, and built-in functions
  ///
  /// The method safely handles expression evaluation errors and missing data,
  /// ensuring analytics don't break the application flow.
  ///
  /// Example with expressions:
  /// ```dart
  /// await AnalyticsHandler.instance.execute(
  ///   context: context,
  ///   events: [
  ///     AnalyticEvent(
  ///       name: 'product_viewed',
  ///       payload: {
  ///         'productId': '${pageArgs.productId}',
  ///         'userId': '${appState.user.id}',
  ///         'viewTime': '${now()}',
  ///         'category': '${product.category}',
  ///       },
  ///     ),
  ///   ],
  ///   enclosing: scopeContext,
  /// );
  /// ```
  Future<void> execute({
    required BuildContext context,
    required List<AnalyticEvent> events,
    ScopeContext? enclosing,
  }) async {
    final logger = DigiaUIManager().logger;

    // Log analytics events for debugging purposes
    _logAnalytics(logger, events, context, enclosing);

    // Evaluate expressions in event payloads and create processed events
    final evaluatedList = events.map((event) {
      final payload = as$<Map<String, dynamic>>(
          evaluateNestedExpressions(event.payload, enclosing));
      return AnalyticEvent(name: event.name, payload: payload);
    }).toList();

    // Forward processed events to the registered analytics handler
    context.analyticsHandler?.onEvent(evaluatedList);
  }
}

/// Internal helper function for logging analytics events to the Digia UI logging system.
///
/// This function processes each analytics event and logs it with the configured logger.
/// It safely handles expression evaluation and provides fallback values for missing data.
///
/// Parameters:
/// - [logger]: The Digia UI logger instance for recording events
/// - [events]: List of analytics events to log
/// - [context]: BuildContext for accessing widget tree data
/// - [enclosing]: Scope context for expression evaluation
///
/// The function evaluates expressions in event payloads and logs both the event name
/// and the processed payload data for debugging and monitoring purposes.
void _logAnalytics(DUILogger? logger, List<AnalyticEvent>? events,
    BuildContext context, ScopeContext? enclosing) {
  // Return early if no events to process
  if (events == null) return;

  // Process each analytics event for logging
  for (var event in events) {
    // Extract event name with fallback to 'Unknown Event'
    String eventName = as$<String>(event.name) ?? 'Unknown Event';

    // Evaluate expressions in payload and provide fallback to empty map
    Map<String, dynamic> eventPayload = as$<Map<String, dynamic>>(
            evaluateNestedExpressions(event.payload ?? {}, enclosing)) ??
        {};

    // Log the processed event to the Digia UI logging system
    logger?.logEvent(eventName: eventName, eventPayload: eventPayload);
  }
}
