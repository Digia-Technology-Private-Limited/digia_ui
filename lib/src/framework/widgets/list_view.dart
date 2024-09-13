import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../internal_widgets/internal_list_view.dart';
import '../render_payload.dart';
import '../stateless_virtual_widget.dart';

class VWListView extends StatelessVirtualWidget {
  VWListView(
    super.props, {
    super.commonProps,
    super.childGroups,
    super.parent,
    super.refName,
    super.repeatData,
  });

  bool get shouldRepeatChild => repeatData != null;

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    final reverse = payload.eval<bool>(props['reverse']) ?? false;
    final scrollDirection = DUIDecoder.toAxis(props['scrollDirection'],
        defaultValue: Axis.vertical);
    final physics = DUIDecoder.toScrollPhysics(props['allowScroll']);
    final shrinkWrap = NumDecoder.toBool(props['shrinkWrap']) ?? false;

    final initialScrollPosition =
        payload.eval<String>(props['initialScrollPosition']);

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
        itemBuilder: (buildContext, index) => childToRepeat.toWidget(
          payload.copyWithChainedContext(
            _createExprContext(items[index], index),
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

  ExprContext _createExprContext(Object? item, int index) {
    return ExprContext(variables: {
      'currentItem': item,
      'index': index
      // TODO: Add class instance using refName
    });
  }
}
