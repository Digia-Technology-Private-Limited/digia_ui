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
class DigiaUIScope extends StatefulWidget {
  /// The message bus instance used for communication within the SDK.
  /// If not provided, a new [MessageBus] instance will be created.
  final MessageBus messageBus;

  /// The widget below this widget in the tree.
  final Widget child;

  final DUIAnalytics? analyticsHandler;

  /// Creates a [DigiaUIScope] widget.
  ///
  /// The [child] parameter must not be null.
  /// If [messageBus] is not provided, a new [MessageBus] instance will be created.
  DigiaUIScope({
    super.key,
    MessageBus? messageBus,
    this.analyticsHandler,
    required this.child,
  }) : messageBus = messageBus ?? MessageBus();

  /// Provides access to the current [_DigiaUIScopeInherited] instance.
  ///
  /// This method is used to access SDK features from descendant widgets.
  /// Will throw an assertion error if no [DigiaUIScope] is found in the widget tree.
  static _DigiaUIScopeInherited of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_DigiaUIScopeInherited>();
    assert(inherited != null, '''
No DigiaUIScope found in context. 
Wrap your app with DigiaUIScope to access SDK features''');
    return inherited!;
  }

  @override
  State<DigiaUIScope> createState() => _DigiaUIScopeState();
}

/// The state for [DigiaUIScope].
class _DigiaUIScopeState extends State<DigiaUIScope> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.messageBus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DigiaUIScopeInherited(
      messageBus: widget.messageBus,
      analyticsHandler: widget.analyticsHandler,
      child: widget.child,
    );
  }
}

/// An [InheritedWidget] that provides access to the [MessageBus] instance.
///
/// This class is used internally by [DigiaUIScope] to propagate the message bus
/// down the widget tree. You typically don't need to use this class directly.
class _DigiaUIScopeInherited extends InheritedWidget {
  /// The message bus instance that will be made available to descendants.
  final MessageBus messageBus;

  final DUIAnalytics? analyticsHandler;

  /// Creates a [_DigiaUIScopeInherited] widget.
  ///
  /// Both [messageBus] and [child] parameters must not be null.
  const _DigiaUIScopeInherited({
    required this.messageBus,
    required this.analyticsHandler,
    required super.child,
  });

  @override
  bool updateShouldNotify(_DigiaUIScopeInherited oldWidget) =>
      messageBus != oldWidget.messageBus;
}
