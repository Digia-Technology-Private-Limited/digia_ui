import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
    final mainAxisSpacing = props.getDouble('mainAxisSpacing');
    final crossAxisSpacing = props.getDouble('crossAxisSpacing');
    final gridDelegate = SliverSimpleGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: props.getInt('crossAxisCount') ?? 2,
    );

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.evalRepeatData(repeatData!);
      return InternalGridView(
        controller: controller,
        physics: physics,
        shrinkWrap: shrinkWrap,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        gridDelegate: gridDelegate,
        itemCount: items.length,
        itemBuilder: (buildContext, index) => childToRepeat.toWidget(
          payload.copyWithChainedContext(
            _createExprContext(items[index], index),
            buildContext: buildContext,
          ),
        ),
      );
    }

    return InternalGridView(
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      gridDelegate: gridDelegate,
      itemCount: children?.length ?? 0,
      itemBuilder: (context, index) =>
          children![index].toWidget(payload.copyWith(buildContext: context)),
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
