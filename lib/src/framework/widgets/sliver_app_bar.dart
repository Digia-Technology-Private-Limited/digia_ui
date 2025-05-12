import 'package:flutter/material.dart';

import '../base/virtual_sliver.dart';
import '../render_payload.dart';
import '../utils/flutter_extensions.dart';
import '../widget_props/sliver_app_bar_props.dart';

class VWSliverAppBar extends VirtualSliver<SliverAppBarProps> {
  VWSliverAppBar({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
    required super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    final bottomPreferredWidth = props.bottomPreferredWidth;
    final bottomPreferredHeight = props.bottomPreferredHeight;
    final collapsedHeight = payload.evalExpr(props.collapsedHeight);
    final expandedHeight = payload.evalExpr(props.expandedHeight);
    final backgroundColor = props.backgroundColor;
    final leadingWidth = props.leadingWidth;
    final titleSpacing = props.titleSpacing;

    return SliverAppBar(
      leading: childOf('leading')?.toWidget(payload) ?? empty(),
      leadingWidth: leadingWidth ?? 0,
      titleSpacing: titleSpacing ?? 0,
      flexibleSpace: FlexibleSpaceBar(
        background: childOf('flexibleSpace')?.toWidget(payload),
      ),
      backgroundColor: payload.evalColor(backgroundColor),
      snap: props.snap ?? false,
      pinned: props.pinned ?? false,
      floating: props.floating ?? false,
      collapsedHeight: collapsedHeight?.toHeight(payload.buildContext),
      expandedHeight: expandedHeight?.toHeight(payload.buildContext),
      title: childOf('title')?.toWidget(payload),
      bottom: PreferredSize(
        preferredSize: Size(
            bottomPreferredWidth?.toWidth(payload.buildContext) ?? 0,
            bottomPreferredHeight?.toWidth(payload.buildContext) ?? 0),
        child: childOf('bottom')?.toWidget(payload) ?? empty(),
      ),
    );
  }
}
