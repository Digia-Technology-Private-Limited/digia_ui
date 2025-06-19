import 'package:flutter/widgets.dart';

/// InheritedWidget that provides navigation bar control functionality
class InheritedScaffoldController extends InheritedWidget {
  final void Function(int index) setCurrentIndex;
  final int currentIndex;

  const InheritedScaffoldController({
    super.key,
    required this.setCurrentIndex,
    required this.currentIndex,
    required super.child,
  });

  /// Retrieves the InheritedScaffoldController from the context or returns null if not found
  static InheritedScaffoldController? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<InheritedScaffoldController>();
  }

  /// Retrieves the InheritedScaffoldController from the context and throws an error if not found
  static InheritedScaffoldController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(
        controller != null, 'No InheritedScaffoldController found in context');
    return controller!;
  }

  @override
  bool updateShouldNotify(InheritedScaffoldController oldWidget) =>
      currentIndex != oldWidget.currentIndex;
}
