import 'package:flutter/widgets.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';

class DUIConditionalBuilderBuilder extends DUIWidgetBuilder {
  DUIConditionalBuilderBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIConditionalBuilderBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIConditionalBuilderBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    final children = data.children['children'];

    if (children == null || children.isEmpty) return const SizedBox.shrink();

    for (final child in children) {

      if (child.type != 'digia/conditionalItem') {
        continue;
      }

      final condition =
          eval<bool>(child.props['condition'], context: context) ?? false;

      if (condition) {
        return DUIWidget( data:  child.children['child']!.first);
      }
    }

    return const SizedBox.shrink();
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Conditional Builder');
  }
}