import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/positioned_props.dart';
import 'positioned.dart';

/// A virtual widget that renders a Stack container
///
/// Stack widgets allow children to be positioned on top of each other,
/// with configurable alignment and fit properties.
class VWStack extends VirtualStatelessWidget<Props> {
  VWStack({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    // Return empty widget if no children are defined
    if (children == null || children!.isEmpty) return empty();

    return Stack(
      alignment: _getChildAlignment,
      fit: _getStackFit,
      children: children!
          .map((child) => _wrapInPositioned(child, payload).toWidget(payload))
          .toList(),
    );
  }

  /// Gets the alignment for stack children from props
  /// Defaults to center alignment if not specified
  AlignmentGeometry get _getChildAlignment =>
      To.stackChildAlignment(props.getString('childAlignment'));

  /// Gets the stack fit mode from props
  /// Determines how the stack should size itself relative to its children
  StackFit get _getStackFit => To.stackFit(props.get('fit'));

  /// Wraps a child widget in Positioned based on parent props
  ///
  /// This method applies positioning properties from the child's parent props
  /// to properly position the child within the stack container.
  VirtualWidget _wrapInPositioned(
      VirtualWidget childVirtualWidget, RenderPayload payload) {
    // Skip wrapping if widget is already positioned
    if (childVirtualWidget is VWPositioned) {
      return childVirtualWidget;
    }

    final parentProps = childVirtualWidget.parentProps;
    if (parentProps == null) return childVirtualWidget;

    final position = parentProps.get('position');
    if (position == null) return childVirtualWidget;

    return VWPositioned(
      props: PositionedProps.fromJson(payload.eval(position)),
      child: childVirtualWidget,
      parent: null,
    );
  }
}
