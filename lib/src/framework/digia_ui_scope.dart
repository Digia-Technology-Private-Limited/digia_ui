import 'package:flutter/widgets.dart';

import '../analytics/dui_analytics.dart';
import 'message_bus.dart';

/// Provides access to Digia UI SDK resources through the widget tree.
/// This widget must be placed above any widgets that need access to the SDK features.
///
/// The [DigiaUIScope] manages a [MessageBus] instance that enables communication
/// between different parts of the application. The message bus can be accessed
/// through [DigiaUIScope.of(context)].
///
/// Example usage:
/// ```dart
/// DigiaUIScope(
///   child: MaterialApp(
///     home: MyHomePage(),
///   ),
/// )
/// ```
class DigiaUIScope extends InheritedWidget {
  /// The message bus instance used for communication within the SDK.
  /// If not provided, a new [MessageBus] instance will be created.
  final MessageBus messageBus;

  final DUIAnalytics? analyticsHandler;

  /// Creates a [DigiaUIScope] widget.
  ///
  /// The [child] parameter must not be null.
  /// If [messageBus] is not provided, a new [MessageBus] instance will be created.
  DigiaUIScope({
    super.key,
    MessageBus? messageBus,
    this.analyticsHandler,
    required super.child,
  }) : messageBus = messageBus ?? MessageBus();

  /// Provides access to the current [DigiaUIScope] instance.
  ///
  /// This method is used to access SDK features from descendant widgets.
  /// Will throw an assertion error if no [DigiaUIScope] is found in the widget tree.
  static DigiaUIScope of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<DigiaUIScope>();
    assert(inherited != null, '''
No DigiaUIScope found in context. 
Wrap your app with DigiaUIScope to access SDK features''');
    return inherited!;
  }

  @override
  bool updateShouldNotify(DigiaUIScope oldWidget) =>
      messageBus != oldWidget.messageBus ||
      analyticsHandler != oldWidget.analyticsHandler;
}
