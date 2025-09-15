import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

/// InheritedWidget that provides ObservabilityContext to the widget subtree
///
/// This eliminates the need to manually thread ObservabilityContext through
/// every action processor call. Widgets can access the current context via
/// ObservabilityScope.of(context) and extend/modify it as needed.
class ObservabilityScope extends InheritedWidget {
  /// The ObservabilityContext available to this subtree
  final ObservabilityContext? value;

  const ObservabilityScope({
    super.key,
    required this.value,
    required super.child,
  });

  /// Retrieves the ObservabilityContext from the widget tree
  ///
  /// Returns null if no ObservabilityScope is found in the ancestor tree
  static ObservabilityContext? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ObservabilityScope>()
        ?.value;
  }

  @override
  bool updateShouldNotify(ObservabilityScope oldWidget) {
    return oldWidget.value != value;
  }
}
