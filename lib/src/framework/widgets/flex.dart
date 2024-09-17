import 'package:collection/collection.dart';
import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../core/extensions.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../core/virtual_stateless_widget.dart';
import '../core/virtual_widget.dart';
import '../render_payload.dart';
import 'flex_fit.dart';

class VWFlex extends VirtualStatelessWidget {
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

    final expansionType =
        childVirtualWidget.commonProps?.getString('expansion.type');
    final flexValue =
        childVirtualWidget.commonProps?.getInt('expansion.flexValue') ?? 1;

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
      mainAxisSize: DUIDecoder.toMainAxisSizeOrDefault(
        props.get('mainAxisSize'),
        defaultValue: MainAxisSize.min,
      ),
      mainAxisAlignment: DUIDecoder.toMainAxisAlginmentOrDefault(
        props.get('mainAxisAlignment'),
        defaultValue: MainAxisAlignment.start,
      ),
      crossAxisAlignment: DUIDecoder.toCrossAxisAlignmentOrDefault(
        props.get('crossAxisAlignment'),
        defaultValue: CrossAxisAlignment.center,
      ),
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
