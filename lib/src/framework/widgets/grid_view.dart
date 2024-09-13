import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../core/extensions.dart';
import '../core/virtual_stateless_widget.dart';
import '../internal_widgets/internal_grid_view.dart';
import '../render_payload.dart';

class VWGridView extends VirtualStatelessWidget {
  VWGridView({
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

    final physics = DUIDecoder.toScrollPhysics(props['allowScroll']);
    final shrinkWrap = NumDecoder.toBool(props['shrinkWrap']) ?? false;
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount:
          NumDecoder.toIntOrDefault(props['crossAxisCount'], defaultValue: 2),
      mainAxisSpacing: NumDecoder.toDoubleOrDefault(props['mainAxisSpacing'],
          defaultValue: 0.0),
      crossAxisSpacing: NumDecoder.toDoubleOrDefault(props['crossAxisSpacing'],
          defaultValue: 0.0),
      childAspectRatio: NumDecoder.toDoubleOrDefault(props['childAspectRatio'],
          defaultValue: 1.0),
    );

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.evalRepeatData(repeatData!);
      return InternalGridView(
        physics: physics,
        shrinkWrap: shrinkWrap,
        gridDelegate: gridDelegate,
        itemCount: items.length,
        itemBuilder: (buildContext, index) => childToRepeat.toWidget(
          payload.copyWithChainedContext(
            _createExprContext(items[index], index),
          ),
        ),
      );
    }

    return InternalGridView(
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: gridDelegate,
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
