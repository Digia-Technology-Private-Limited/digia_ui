import 'package:digia_ui/Utils/dui_widget_list_registry.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:digia_ui/core/grid/dui_grid_view.props.dart';
import 'package:flutter/material.dart';

class DUIGridView extends StatelessWidget {
  final DUIGridViewProps props;

  const DUIGridView(this.props, {super.key}) : super();

  factory DUIGridView.create(Map<String, dynamic> json) =>
      DUIGridView(DUIGridViewProps.fromJson(json));

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: props.children.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: props.crossAxisCount,
            mainAxisSpacing: resolveSpacing(props.mainAxisSpacing),
            crossAxisSpacing: resolveSpacing(props.crossAxisSpacing),
            childAspectRatio: props.childAspectRatio ?? 1.0),
        itemBuilder: (context, index) {
          final childContainer = props.children[index];
          final widget = DUIWidgetRegistry[childContainer.child.type]
              ?.call(childContainer.child.data);
          return childContainer.styleClass == null
              ? widget
              : DUIContainer(
                  styleClass: childContainer.styleClass, child: widget);
        });
  }
}
