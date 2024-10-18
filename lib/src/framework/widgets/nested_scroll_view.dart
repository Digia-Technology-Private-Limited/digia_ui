import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../data_type/compex_object.dart';
import '../data_type/data_type.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../render_payload.dart';
import '../widget_props/nested_scroll_view_props.dart';

class NestedScrollViewData extends InheritedWidget {
  final bool
      enableOverlapAbsorption; // Replace SomeDataType with your actual data type

  const NestedScrollViewData({
    super.key,
    required this.enableOverlapAbsorption,
    required super.child,
  });

  static NestedScrollViewData? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<NestedScrollViewData>();
  }

  @override
  bool updateShouldNotify(NestedScrollViewData oldWidget) => false;
}

class VWNestedScrollView extends VirtualStatelessWidget<NestedScrollViewProps> {
  VWNestedScrollView({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
    required super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    final dataType =
        DataTypeFetch.dataType<ScrollController>(props.dataType, payload);

    final enableOverlapAbsorption =
        props.enableOverlapAbsorber?.evaluate(payload.scopeContext) ?? true;

    final header = childrenOf('headerWidget')?.firstOrNull;
    final body = childOf('bodyWidget');

    return NestedScrollView(
        controller: dataType,
        headerSliverBuilder: (innerCtx, innerBoxIsScrolled) {
          final updatedPayload = payload.copyWithChainedContext(
            _createExprContext(innerBoxIsScrolled),
            buildContext: innerCtx,
          );

          var output = header?.toWidget(updatedPayload) ??
              SliverToBoxAdapter(child: empty());

          if (enableOverlapAbsorption) {
            output = SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(innerCtx),
              sliver: output,
            );
          }

          return <Widget>[output];
        },
        body: NestedScrollViewData(
          enableOverlapAbsorption: enableOverlapAbsorption,
          child: Builder(builder: (innerCtx) {
            final updatedPayload = payload.copyWith(buildContext: innerCtx);
            return body?.toWidget(updatedPayload) ?? empty();
          }),
        ));
  }

  ScopeContext _createExprContext(bool? value) {
    return DefaultScopeContext(variables: {
      'innerBoxIsScrolled': value,
    });
  }
}
