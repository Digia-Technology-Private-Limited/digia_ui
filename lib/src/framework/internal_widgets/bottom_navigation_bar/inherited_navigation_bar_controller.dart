import 'package:flutter/widgets.dart';

/// InheritedWidget that provides navigation bar item index information
class InheritedNavigationBarController extends InheritedWidget {
  final int itemIndex;

  const InheritedNavigationBarController({
    super.key,
    required this.itemIndex,
    required super.child,
  });

  /// Retrieves the InheritedNavigationBarController from the context or returns null if not found
  static InheritedNavigationBarController? maybeOf(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<InheritedNavigationBarController>();
  }

  /// Retrieves the InheritedNavigationBarController from the context and throws an error if not found
  static InheritedNavigationBarController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(controller != null,
        'No InheritedNavigationBarController found in context');
    return controller!;
  }

  @override
  bool updateShouldNotify(InheritedNavigationBarController oldWidget) =>
      itemIndex != oldWidget.itemIndex;
}
