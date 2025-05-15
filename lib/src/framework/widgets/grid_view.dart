import 'package:flutter/widgets.dart';

import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../data_type/adapted_types/scroll_controller.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_grid_view.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWGridView extends VirtualStatelessWidget<Props> {
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

    final controller =
        payload.eval<AdaptedScrollController>(props.get('controller'));

    final physics = To.scrollPhysics(props.get('allowScroll'));
    final shrinkWrap = props.getBool('shrinkWrap') ?? false;
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: props.getInt('crossAxisCount') ?? 2,
      mainAxisSpacing: props.getDouble('mainAxisSpacing') ?? 0.0,
      crossAxisSpacing: props.getDouble('crossAxisSpacing') ?? 0.0,
      childAspectRatio: props.getDouble('childAspectRatio') ?? 1.0,
      mainAxisExtent: props.getDouble('mainAxisExtent'),
    );

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.evalRepeatData(repeatData!);
      return InternalGridView(
        controller: controller,
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
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: gridDelegate,
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
