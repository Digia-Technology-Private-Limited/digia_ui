import 'package:collection/collection.dart';
import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../base/extensions.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import 'flex_fit.dart';

class VWFlex extends VirtualStatelessWidget<Props> {
  final Axis direction;

  VWFlex({
    required this.direction,
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
    required super.childGroups,
    required super.repeatData,
  });

  bool get shouldRepeatChild => repeatData != null;

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    Widget widget;
    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.evalRepeatData(repeatData!);
      widget = _buildFlex(
        () => items.mapIndexed((index, item) {
          return _wrapInFlexFitForBackwardCompat(childToRepeat).toWidget(
            payload.copyWithChainedContext(
              _createExprContext(item, index),
            ),
          );
        }).toList(),
      );
    } else {
      widget = _buildFlex(
        () => children!
            .map(_wrapInFlexFitForBackwardCompat)
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
      VirtualWidget childVirtualWidget) {
    // Ignore if widget is already wrapped in FlexFit
    if (childVirtualWidget is! VirtualLeafStatelessWidget ||
        childVirtualWidget is VWFlexFit) {
      return childVirtualWidget;
    }

    final expansionType = childVirtualWidget.commonProps?.parentProps
        ?.getString('expansion.type');
    final flexValue = childVirtualWidget.commonProps?.parentProps
            ?.getInt('expansion.flexValue') ??
        1;

    if (expansionType == null) return childVirtualWidget;

    return VWFlexFit.fromValues(
      flexFitType: expansionType,
      flexValue: flexValue,
      child: childVirtualWidget,
      parent: this,
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

  ExprContext _createExprContext(Object? item, int index) {
    return ExprContext(variables: {
      'currentItem': item,
      'index': index
      // TODO: Add class instance using refName
    });
  }
}
