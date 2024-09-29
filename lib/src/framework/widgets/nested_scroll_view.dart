import 'package:flutter/widgets.dart';

import '../../Utils/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';

class VWNestedScrollView extends VirtualStatelessWidget<Props> {
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
    return NestedScrollView(
      headerSliverBuilder: (cntx, innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(cntx),
            sliver: getHeaderWidget(innerBoxIsScrolled, payload),
          ),
        ];
      },
      body: childOf('bodyWidget')?.toWidget(payload) ?? empty(),
    );
  }

  Widget? getHeaderWidget(bool innerBoxIsScrolled, RenderPayload payload) {
    final headerWidgetData = childrenOf('headerWidget');

    if (headerWidgetData == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final headerWidget = headerWidgetData.maybe((e) {
      if (e.isNullOrEmpty) return null;

      return e.first.toWidget(payload
          .copyWithChainedContext(_createExprContext(innerBoxIsScrolled)));
    });
    return headerWidget;
  }

  ScopeContext _createExprContext(bool? value) {
    return DefaultScopeContext(variables: {
      'innerBoxIsScrolled': value,
    });
  }
}
