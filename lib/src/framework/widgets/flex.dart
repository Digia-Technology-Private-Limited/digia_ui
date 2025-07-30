import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../base/extensions.dart';
import '../base/virtual_leaf_stateless_widget.dart';
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

class VWFlex extends VirtualStatelessWidget<Props> {
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

  bool get shouldRepeatChild => props.get('dataSource') != null;

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    Widget widget;
    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.eval<List<Object>>(props.get('dataSource')) ?? [];
      widget = _buildFlex(
        () => items.mapIndexed((index, item) {
          return _wrapInFlexFitForBackwardCompat(childToRepeat, payload)
              .toWidget(
            payload.copyWithChainedContext(
              _createExprContext(item, index),
            ),
          );
        }).toList(),
      );
    } else {
      widget = _buildFlex(
        () => children!
            .map((child) => _wrapInFlexFitForBackwardCompat(child, payload))
            .toWidgetArray(payload),
      );
    }

    if (props.getBool('isScrollable') == true) {
      return SingleChildScrollView(
        scrollDirection: direction,
        child: widget,
      );
    }

    return widget;
  }

  // This is for backward compatibility:
  VirtualWidget _wrapInFlexFitForBackwardCompat(
      VirtualWidget childVirtualWidget, RenderPayload payload) {
    // Ignore if widget is already wrapped in FlexFit
    if (childVirtualWidget is! VirtualLeafStatelessWidget ||
        childVirtualWidget is VWFlexFit) {
      return childVirtualWidget;
    }

    final expansionType =
        childVirtualWidget.parentProps?.getString('expansion.type');
    final flexValue = payload
        .eval<int>(childVirtualWidget.parentProps?.get('expansion.flexValue'));

    if (expansionType == null) return childVirtualWidget;

    return VWFlexFit.withChild(
      props: FlexFitProps(
        flexFitType: expansionType,
        flexValue: flexValue,
      ),
      child: childVirtualWidget,
    );
  }

  Widget _buildFlex(List<Widget> Function() childrenBuilder) {
    return Flex(
      direction: direction,
      mainAxisSize:
          To.mainAxisSize(props.get('mainAxisSize')) ?? MainAxisSize.min,
      mainAxisAlignment: To.mainAxisAlginment(props.get('mainAxisAlignment')) ??
          MainAxisAlignment.start,
      crossAxisAlignment:
          To.crossAxisAlignment(props.get('crossAxisAlignment')) ??
              CrossAxisAlignment.center,
      children: childrenBuilder(),
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    final flexObj = {
      'currentItem': item,
      'index': index,
    };

    return DefaultScopeContext(variables: {
      ...flexObj,
      ...?refName.maybe((it) => {it: flexObj}),
    });
  }
}
