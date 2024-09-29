import 'package:flutter/material.dart';

import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWSliverAppBar extends VirtualStatelessWidget<Props> {
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
    final bottomPreferredWidth = props.getString('bottomPreferredWidth');
    final bottomPreferredHeight = props.getString('bottomPreferredHeight');
    final collapsedHeight = props.getString('collapsedHeight');
    final expandedHeight = props.getString('expandedHeight');
    final backgroundColor = props.getString('backgroundColor');
    final leadingWidth = props.getDouble('leadingWidth');
    final titleSpacing = props.getDouble('titleSpacing');

    return SliverAppBar(
      leading: childOf('leading')?.toWidget(payload),
      leadingWidth: leadingWidth ?? 0,
      titleSpacing: titleSpacing ?? 0,
      flexibleSpace: childOf('flexibleSpace')?.toWidget(payload),
      backgroundColor: makeColor(backgroundColor),
      snap: props.getBool('snap') ?? false,
      pinned: props.getBool('pinned') ?? false,
      floating: props.getBool('floating') ?? false,
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
