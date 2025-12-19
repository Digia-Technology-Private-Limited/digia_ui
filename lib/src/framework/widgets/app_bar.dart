import 'package:flutter/material.dart';

import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../utils/flutter_extensions.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/app_bar_props.dart';
import 'text.dart';

class VWAppBar extends VirtualStatelessWidget<AppBarProps> {
  VWAppBar({
    required super.props,
    required super.parent,
    super.parentProps,
    super.refName,
    required super.childGroups,
  }) :
        // Since this is a PrefferedSizeWidget,
        // we shouldn't wrap any Widget around it.
        super(commonProps: null);

  @override
  Widget render(RenderPayload payload) {
    final toolbarHeight = props.toolbarHeight != null
        ? payload.evalExpr(props.toolbarHeight)?.toHeight(payload.buildContext)
        : null;
    final bottomSectionHeight = props.bottomSectionHeight != null
        ? payload
            .evalExpr(props.bottomSectionHeight)
            ?.toHeight(payload.buildContext)
        : null;
    final bottomSectionWidth = props.bottomSectionWidth != null
        ? payload
            .evalExpr(props.bottomSectionWidth)
            ?.toWidth(payload.buildContext)
        : null;

    final centerTitle = payload.evalExpr(props.centerTitle) ?? false;
    final titleSpacing = payload.evalExpr(props.titleSpacing);
    final shape = To.buttonShape(props.shape, payload.getColor);
    final useFlexibleSpace = payload.evalExpr(props.useFlexibleSpace) ?? false;
    final titlePadding = To.edgeInsets(props.titlePadding);
    final automaticallyImplyLeading =
        payload.evalExpr(props.automaticallyImplyLeading) ?? true;
    final defaultButtonColor = payload.evalColorExpr(props.defaultButtonColor);
    final collapseMode = CollapseMode.values
        .byName(payload.evalExpr(props.collapseMode) ?? 'parallax');
    final expandedTitleScale =
        payload.evalExpr(props.expandedTitleScale)?.toDouble() ?? 1.5;

    Widget? flexibleSpaceWidget;
    if (useFlexibleSpace) {
      flexibleSpaceWidget = FlexibleSpaceBar(
        title: _buildTitle(payload),
        centerTitle: centerTitle,
        titlePadding: titlePadding,
        background: childOf('background')?.toWidget(payload),
        collapseMode: collapseMode,
        expandedTitleScale: expandedTitleScale,
      );
    } else if (childOf('background') != null) {
      flexibleSpaceWidget = FlexibleSpaceBar(
        background: childOf('background')?.toWidget(payload),
      );
    }

    return AppBar(
      title: useFlexibleSpace ? null : _buildTitle(payload),
      elevation: payload.evalExpr(props.elevation)?.toDouble(),
      shadowColor: payload.evalColorExpr(props.shadowColor),
      backgroundColor: payload.evalColorExpr(props.backgroundColor),
      iconTheme: automaticallyImplyLeading && defaultButtonColor != null
          ? IconThemeData(color: defaultButtonColor)
          : null,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: _buildLeading(payload),
      actions: _buildActions(payload),
      centerTitle: useFlexibleSpace ? false : centerTitle,
      titleSpacing: titleSpacing?.toDouble(),
      toolbarHeight: toolbarHeight,
      shape: shape,
      flexibleSpace: flexibleSpaceWidget,
      bottom: childOf('bottom') != null
          ? PreferredSize(
              preferredSize:
                  Size(bottomSectionWidth ?? 0, bottomSectionHeight ?? 0),
              child: childOf('bottom')?.toWidget(payload) ?? Container(),
            )
          : null,
    );
  }

  Widget _buildTitle(RenderPayload payload) {
    if (childOf('title') != null) {
      return childOf('title')!.toWidget(payload);
    }
    return VWText(
      props: props.title,
      commonProps: null,
    ).toWidget(payload);
  }

  Widget? _buildLeading(RenderPayload payload) {
    return childOf('leading')?.toWidget(payload);
  }

  List<Widget>? _buildActions(RenderPayload payload) {
    return childrenOf('actions')?.map((e) => e.toWidget(payload)).toList();
  }
}
