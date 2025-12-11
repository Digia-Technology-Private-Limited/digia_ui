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
import '../utils/functional_util.dart';

class VWGridView extends VirtualStatelessWidget<Props> {
  VWGridView({
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

    final physics = To.scrollPhysics(props.get('allowScroll'));
    final shrinkWrap = props.getBool('shrinkWrap') ?? false;
    final mainAxisSpacing = props.getDouble('mainAxisSpacing');
    final crossAxisSpacing = props.getDouble('crossAxisSpacing');
    final scrollDirection = To.axis(props.get('scrollDirection'));
    final gridDelegate = SliverSimpleGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: props.getInt('crossAxisCount') ?? 2,
    );

    if (shouldRepeatChild) {
      final items = payload.eval<List<Object>>(props.get('dataSource')) ?? [];
      return InternalGridView(
        controller: controller,
        physics: physics,
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        gridDelegate: gridDelegate,
        itemCount: items.length,
        itemBuilder: (buildContext, index) => child!.toWidget(
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
      scrollDirection: scrollDirection,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      gridDelegate: gridDelegate,
      itemBuilder: (context, index) =>
          child?.toWidget(payload.copyWith(buildContext: context)) ?? empty(),
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    final gridObj = {
      'currentItem': item,
      'index': index,
    };

    return DefaultScopeContext(variables: {
      ...gridObj,
      ...?refName.maybe((it) => {it: gridObj}),
    });
  }
}
