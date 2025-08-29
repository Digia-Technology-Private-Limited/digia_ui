import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../widget_props/flex_fit_props.dart';
import 'flex_fit.dart';

/// A virtual widget that renders a Flex container (Row/Column)
///
/// This widget supports:
/// - Dynamic data source rendering with iteration over collections
/// - Configurable flex properties (direction, alignment, sizing)
/// - Optional scrolling when content overflows
class VWFlex extends VirtualStatelessWidget<Props> {
  /// The direction of the flex container (horizontal for Row, vertical for Column)
  final Axis direction;

  VWFlex({
    required this.direction,
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
    required super.childGroups,
  });

  /// Determines if this flex should repeat its child for each item in a data source
  bool get shouldRepeatChild => props.get('dataSource') != null;

  @override
  Widget render(RenderPayload payload) {
    // Return empty widget if no children are defined
    if (children == null || children!.isEmpty) return empty();

    final flexWidget = shouldRepeatChild
        ? _buildRepeatingFlex(payload)
        : _buildStaticFlex(payload);

    // Wrap in scroll view if scrolling is enabled
    return _wrapWithScrollViewIfNeeded(flexWidget);
  }

  /// Builds a flex widget with repeating children from a data source
  Widget _buildRepeatingFlex(RenderPayload payload) {
    final childToRepeat = children!.first;
    final dataItems = payload.eval<List<Object>>(props.get('dataSource')) ?? [];

    return _buildFlex(() {
      return dataItems.mapIndexed((index, item) {
        // Create a scoped context for each data item
        final scopedPayload = payload.copyWithChainedContext(
          _createExprContext(item, index),
        );
        // Apply parent props via FlexFit wrapper
        return _wrapInFlexFit(childToRepeat, scopedPayload)
            .toWidget(scopedPayload);
      }).toList();
    });
  }

  /// Builds a flex widget with static children
  Widget _buildStaticFlex(RenderPayload payload) {
    return _buildFlex(() {
      return children!
          .map((child) => _wrapInFlexFit(child, payload))
          .toWidgetArray(payload);
    });
  }

  /// Wraps the flex widget in a SingleChildScrollView if scrolling is enabled
  Widget _wrapWithScrollViewIfNeeded(Widget flexWidget) {
    final isScrollable = props.getBool('isScrollable') == true;

    if (isScrollable) {
      return SingleChildScrollView(
        scrollDirection: direction,
        child: flexWidget,
      );
    }

    return flexWidget;
  }

  /// Wraps a child widget in FlexFit based on parent props
  ///
  /// This method applies flex properties (expansion type and flex value)
  /// from the child's parent props to properly control how the child behaves
  /// within the flex container.
  VirtualWidget _wrapInFlexFit(
      VirtualWidget childVirtualWidget, RenderPayload payload) {
    // Skip wrapping if widget is already a FlexFit
    if (childVirtualWidget is VWFlexFit) {
      return childVirtualWidget;
    }

    final parentProps = childVirtualWidget.parentProps;
    if (parentProps == null) return childVirtualWidget;

    final expansionType = parentProps.getString('expansion.type');
    final flexValue = payload.eval<int>(parentProps.get('expansion.flexValue'));

    // Only wrap if expansion type is specified
    if (expansionType == null) return childVirtualWidget;

    return VWFlexFit.withChild(
      props: FlexFitProps(
        flexFitType: expansionType,
        flexValue: flexValue,
      ),
      child: childVirtualWidget,
    );
  }

  /// Creates the core Flex widget with configured properties
  Widget _buildFlex(List<Widget> Function() childrenBuilder) {
    return Flex(
      direction: direction,
      mainAxisSize:
          To.mainAxisSize(props.get('mainAxisSize')) ?? MainAxisSize.min,
      mainAxisAlignment: To.mainAxisAlignment(props.get('mainAxisAlignment')) ??
          MainAxisAlignment.start,
      crossAxisAlignment:
          To.crossAxisAlignment(props.get('crossAxisAlignment')) ??
              CrossAxisAlignment.center,
      children: childrenBuilder(),
    );
  }

  /// Creates expression context for data source items
  ///
  /// Provides access to:
  /// - currentItem: The current data item
  /// - index: The current item's index
  /// - refName (optional): Named reference to the context object
  ScopeContext _createExprContext(Object? item, int index) {
    final flexObj = {
      'currentItem': item,
      'index': index,
    };

    return DefaultScopeContext(variables: {
      ...flexObj,
      // Add named reference if refName is provided
      ...?refName.maybe((name) => {name: flexObj}),
    });
  }
}
