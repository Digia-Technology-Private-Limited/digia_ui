import 'dart:async';

/// Represents an event that can be dispatched through the message bus
class UIEvent {
  final String name;
  final Object? payload;

  const UIEvent({
    required this.name,
    this.payload,
  });

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

  /// Listens for [UIEvent]s with the specified name.
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
  Stream<UIEvent> on([String? eventName]) {
    if (eventName == null) {
      return streamController.stream.cast<UIEvent>();
    } else {
      return streamController.stream
          .where((message) => message is UIEvent && message.name == eventName)
          .cast<UIEvent>();
    }
  }

  /// Sends an event through the message bus.
  ///
  /// Example:
  /// ```dart
  /// messageBus.send(UIEvent(name: 'analytics', data: {'event': 'button_click'}));
  /// ```
  void send(UIEvent event) {
    streamController.add(event);
  }

  /// Closes the message bus and cleans up resources.
  /// This should only be called when the SDK is being disposed.
  void dispose() {
    _streamController.close();
  }
}
