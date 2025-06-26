import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWWrap extends VirtualStatelessWidget<Props> {
  VWWrap({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  bool get shouldRepeatChild => props.get('dataSource') != null;

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    List<Widget> wrapChildren;

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.eval<List<Object>>(props.get('dataSource')) ?? [];
      wrapChildren = items.mapIndexed((index, item) {
        return childToRepeat.toWidget(
          payload.copyWithChainedContext(
            _createExprContext(item, index),
          ),
        );
      }).toList();
    } else {
      wrapChildren = children!.toWidgetArray(payload);
    }

    return Wrap(
      spacing: payload.eval<double>(props.get('spacing')) ?? 0,
      alignment:
          To.wrapAlignment(payload.eval<String>(props.get('wrapAlignment'))) ??
              WrapAlignment.start,
      crossAxisAlignment: To.wrapCrossAlignment(
              payload.eval<String>(props.get('wrapCrossAlignment'))) ??
          WrapCrossAlignment.start,
      direction: To.axis(payload.eval<String>(props.get('direction'))) ??
          Axis.horizontal,
      runSpacing: payload.eval<double>(props.get('runSpacing')) ?? 0,
      runAlignment:
          To.wrapAlignment(payload.eval<String>(props.get('runAlignment'))) ??
              WrapAlignment.start,
      verticalDirection: To.verticalDirection(
              payload.eval<String>(props.get('verticalDirection'))) ??
          VerticalDirection.down,
      clipBehavior:
          To.clip(payload.eval<String>(props.get('clipBehavior'))) ?? Clip.none,
      children: wrapChildren,
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    return DefaultScopeContext(variables: {
      'currentItem': item,
      'index': index,
    });
  }
}
