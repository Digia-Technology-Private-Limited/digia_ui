import 'package:flutter/widgets.dart';

import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_list_view.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWListView extends VirtualStatelessWidget<Props> {
  VWListView({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    required super.repeatData,
  });

  bool get shouldRepeatChild => repeatData != null;

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    final reverse = payload.eval<bool>(props.get('reverse')) ?? false;
    final scrollDirection =
        To.axis(props.get('scrollDirection')) ?? Axis.vertical;
    final physics = To.scrollPhysics(props.get('allowScroll'));
    final shrinkWrap = props.getBool('shrinkWrap') ?? false;

    final initialScrollPosition =
        payload.eval<String>(props.get('initialScrollPosition'));

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.evalRepeatData(repeatData!);
      return InternalListView(
        reverse: reverse,
        scrollDirection: scrollDirection,
        physics: physics,
        shrinkWrap: shrinkWrap,
        initialScrollPosition: initialScrollPosition,
        itemCount: items.length,
        itemBuilder: (innerCtx, index) => childToRepeat.toWidget(
          payload.copyWithChainedContext(
            _createExprContext(items[index], index),
            buildContext: innerCtx,
          ),
        ),
      );
    }

    return InternalListView(
      reverse: reverse,
      scrollDirection: scrollDirection,
      physics: physics,
      shrinkWrap: shrinkWrap,
      initialScrollPosition: initialScrollPosition,
      children: children?.toWidgetArray(payload) ?? [],
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    return DefaultScopeContext(variables: {
      'currentItem': item,
      'index': index
      // TODO: Add class instance using refName
    });
  }
}
