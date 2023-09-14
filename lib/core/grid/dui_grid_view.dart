import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIGridView extends StatelessWidget {
  final DUIWidgetJsonData props;

  const DUIGridView(this.props, {super.key}) : super();

  factory DUIGridView.create(Map<String, dynamic> json) =>
      DUIGridView(DUIWidgetJsonData.fromJson(json));

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();

    // return GridView.builder(
    //     physics: const NeverScrollableScrollPhysics(),
    //     shrinkWrap: true,
    //     itemCount: props.children.length,
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: props.crossAxisCount,
    //         mainAxisSpacing: resolveSpacing(props.mainAxisSpacing),
    //         crossAxisSpacing: resolveSpacing(props.crossAxisSpacing),
    //         childAspectRatio: props.childAspectRatio ?? 1.0),
    //     itemBuilder: (context, index) {
    //       final childContainer = props.children[index];
    //       final widget = DUIWidgetRegistry[childContainer.child.type]
    //           ?.call(childContainer.child.data);
    //       return childContainer.styleClass == null
    //           ? widget
    //           : DUIContainer(
    //               styleClass: childContainer.styleClass, child: widget);
    //     });
  }
}
