import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../data_type/adapted_types/scroll_controller.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_list_view.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';

class VWListView extends VirtualStatelessWidget<Props> {
  VWListView({
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
    if (child == null) return empty();

    final controller =
        payload.eval<AdaptedScrollController>(props.get('controller'));

    final reverse = payload.eval<bool>(props.get('reverse')) ?? false;
    final scrollDirection =
        To.axis(props.get('scrollDirection')) ?? Axis.vertical;
    final physics = To.scrollPhysics(props.get('allowScroll'));
    final shrinkWrap = props.getBool('shrinkWrap') ?? false;

    final initialScrollPosition =
        payload.eval<String>(props.get('initialScrollPosition'));

    if (shouldRepeatChild) {
      final items = payload.eval<List<Object>>(props.get('dataSource')) ?? [];
      return InternalListView(
        controller: controller,
        reverse: reverse,
        scrollDirection: scrollDirection,
        physics: physics,
        shrinkWrap: shrinkWrap,
        initialScrollPosition: initialScrollPosition,
        itemCount: items.length,
        itemBuilder: (innerCtx, index) =>
            child?.toWidget(
              payload.copyWithChainedContext(
                _createExprContext(items[index], index),
                buildContext: innerCtx,
              ),
            ) ??
            empty(),
      );
    }

    return InternalListView(
      controller: controller,
      reverse: reverse,
      scrollDirection: scrollDirection,
      physics: physics,
      shrinkWrap: shrinkWrap,
      initialScrollPosition: initialScrollPosition,
      children: [child?.toWidget(payload) ?? empty()],
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    final listObj = {
      'currentItem': item,
      'index': index,
    };

    return DefaultScopeContext(
      variables: {
        ...listObj,
        ...?refName.maybe((it) => {it: listObj}),
      },
    );
  }
}
