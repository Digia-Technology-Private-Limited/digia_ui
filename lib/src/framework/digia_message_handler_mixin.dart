import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../digia_ui.dart';

/// A mixin that provides message handling capabilities for StatefulWidget states.
///
/// This mixin allows widgets to easily subscribe to and handle messages from the
/// [MessageBus] provided by [DigiaUIScope]. It automatically manages subscriptions
/// and cleanup.
///
/// Example usage:
/// ```dart
/// class _MyWidgetState extends State<MyWidget> with DigiaMessageHandlerMixin {
///   @override
///   void initState() {
///     super.initState();
///     registerMessageHandler('eventName', (message) {
///       // Handle message
///     });
///   }
/// }
/// ```
mixin DigiaMessageHandlerMixin<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _messageSubscriptions = [];
  final Map<String, void Function(Message)> _messageHandlers = {};

  /// Registers a handler function for a specific message event.
  ///
  /// [eventName] is the name of the event to listen for.
  /// [handler] is the function that will be called when the event is received.
  void addMessageHandler(String eventName, void Function(Message) handler) {
    if (eventName.isEmpty) {
      throw ArgumentError('Event name cannot be empty');
    }
    if (_messageHandlers.containsKey(eventName)) {
      throw StateError('Handler already registered for event: $eventName');
    }
    _messageHandlers[eventName] = handler;
  }

  @override
  void didChangeDependencies() {
    _unsubscribeFromMessages();
    _subscribeToMessages();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _unsubscribeFromMessages();
    super.dispose();
  }

  /// Cancels all message subscriptions and clears the handlers.
  void _unsubscribeFromMessages() {
    for (final subscription in _messageSubscriptions) {
      subscription.cancel();
    }
    _messageSubscriptions.clear();
  }

  /// Sets up subscriptions for all registered message handlers.
  void _subscribeToMessages() {
    final messageBus = DigiaUIScope.of(context).messageBus;

    for (final entry in _messageHandlers.entries) {
      try {
        final subscription = messageBus.on(entry.key).listen(entry.value);
        _messageSubscriptions.add(subscription);
      } catch (e) {
        // Log or handle subscription errors
        assert(() {
          print('Error subscribing to message ${entry.key}: $e');
          return true;
        }());
      }
    }
  }
}
