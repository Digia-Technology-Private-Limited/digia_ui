import 'package:flutter/widgets.dart';

import '../base/extensions.dart';
import '../base/virtual_builder_widget.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/positioned_props.dart';
import 'positioned.dart';

class VWStack extends VirtualStatelessWidget<Props> {
  VWStack(
      {required super.props,
      required super.commonProps,
      super.parentProps,
      required super.childGroups,
      required super.parent,
      super.refName});

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    return Stack(
        alignment: To.stackChildAlignment(props.getString('childAlignment')),
        fit: To.stackFit(props.get('fit')),
        children: children!
            .map(_wrapInPositionedForBackwardCompat)
            .toWidgetArray(payload));
  }

  // This is for backward compatibility:
  VirtualWidget _wrapInPositionedForBackwardCompat(
      VirtualWidget childVirtualWidget) {
    // Ignore if widget is already wrapped in Positioned
    if (childVirtualWidget is VWPositioned) {
      return childVirtualWidget;
    }

    // Check if widget is VirtualLeafStatelessWidget or VirtualBuilderWidget
    if (childVirtualWidget is! VirtualLeafStatelessWidget &&
        childVirtualWidget is! VirtualBuilderWidget) {
      return childVirtualWidget;
    }

    // Cast to access parentProps
    final parentProps = childVirtualWidget is VirtualLeafStatelessWidget
        ? childVirtualWidget.parentProps
        : (childVirtualWidget as VirtualBuilderWidget).parentProps;

    final position = parentProps?.get('position');
    if (position == null) return childVirtualWidget;

    return VWPositioned(
      props: PositionedProps.fromJson(position),
      child: childVirtualWidget,
      parent: null,
    );
  }
}
