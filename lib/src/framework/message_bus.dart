import 'dart:async';

import 'package:flutter/widgets.dart';

/// Represents an event that can be dispatched through the message bus
class Message {
  final String name;
  final Object? payload;

  /// Optional build context that can be used to access widget tree information.
  /// This is useful for showing dialogs, snackbars, or other UI elements in response to messages.
  final BuildContext? _context;

  const Message({
    required this.name,
    this.payload,
    BuildContext? context,
  }) : _context = context;

  /// WARNING: This context comes from deep within the SDK and should be used with extreme caution.
  /// Misusing this context can lead to multiple problems including:
  /// - Memory leaks if stored improperly
  /// - Incorrect widget tree traversal
  /// - Unexpected UI behavior
  /// Only use when absolutely necessary and ensure proper context lifecycle management.
  BuildContext? getMountedContext() =>
      _context?.mounted == true ? _context : null;

  @override
  String toString() => 'UIEvent(name: $name, payload: $payload)';
}

class MessageBus {
  final StreamController _streamController;

  /// Controller for the message bus stream.
  StreamController get streamController => _streamController;

  /// Creates a [MessageBus] for handling communication between the DUI SDK and native code.
  MessageBus() : _streamController = StreamController.broadcast();

  /// Instead of using the default [StreamController] you can use this constructor
  /// to pass your own controller.
  ///
  /// This allows for custom message handling implementations if needed.
  MessageBus.customController(StreamController controller)
      : _streamController = controller;

  /// Listens for [Message]s with the specified name.
  ///
  /// Usage example:
  /// ```dart
  /// // Store subscription in a field
  /// late final StreamSubscription _buttonClickSubscription;
  ///
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   _buttonClickSubscription = messageBus.on('button_click').listen((event) {
  ///     // Handle event
  ///   });
  /// }
  ///
  /// @override
  /// void dispose() {
  ///   // Cancel subscription when widget is disposed
  ///   _buttonClickSubscription.cancel();
  ///   super.dispose();
  /// }
  /// ```
  ///
  /// IMPORTANT: Remember to store the returned [StreamSubscription] and cancel it
  /// in your dispose method to avoid memory leaks.
  ///
  /// If called without a name parameter, the [Stream] contains every
  /// event passing through this [MessageBus].
  ///
  /// The returned [Stream] is a broadcast stream so multiple subscriptions are
  /// allowed.
  Stream<Message> on([String? eventName]) {
    if (eventName == null) {
      return streamController.stream.cast<Message>();
    } else {
      return streamController.stream
          .where((message) => message is Message && message.name == eventName)
          .cast<Message>();
    }
  }

  /// Sends an event through the message bus.
  ///
  /// Example:
  /// ```dart
  /// messageBus.send(UIEvent(name: 'analytics', data: {'event': 'button_click'}));
  /// ```
  void send(Message event) {
    streamController.add(event);
  }

  /// Closes the message bus and cleans up resources.
  /// This should only be called when the SDK is being disposed.
  void dispose() {
    _streamController.close();
  }
}
