import 'package:flutter/material.dart';

import '../base/virtual_sliver.dart';
import '../render_payload.dart';
import '../utils/flutter_extensions.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/sliver_app_bar_props.dart';
import 'text.dart';

class VWSliverAppBar extends VirtualSliver<SliverAppBarProps> {
  VWSliverAppBar({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
  });

  @override
  Widget render(RenderPayload payload) {
    final collapsedHeight = payload.evalExpr(props.collapsedHeight);
    final expandedHeight = payload.evalExpr(props.expandedHeight);
    final backgroundColor = payload.evalColorExpr(props.backgroundColor);
    final shadowColor = payload.evalColor(props.shadowColor);
    final elevation = payload.evalExpr(props.elevation);

    final centerTitle = payload.evalExpr(props.centerTitle) ?? false;
    final titleSpacing = payload.evalExpr(props.titleSpacing);
    final toolbarHeight = payload.evalExpr(props.toolbarHeight);

    final useFlexibleSpace = payload.evalExpr(props.useFlexibleSpace) ?? false;
    final titlePadding = To.edgeInsets(props.titlePadding);

    final pinned = payload.evalExpr(props.pinned) ?? true;
    final floating = payload.evalExpr(props.floating) ?? false;
    final snap = payload.evalExpr(props.snap) ?? false;

    final bottomSectionHeight = payload.evalExpr(props.bottomSectionHeight);
    final bottomSectionWidth = payload.evalExpr(props.bottomSectionWidth);

    final showDefaultButton =
        payload.evalExpr(props.automaticallyImplyLeading) ?? true;
    final defaultButtonColor = payload.evalColor(props.defaultButtonColor);

    final shape = To.buttonShape(props.shape, payload.getColor);

    final collapseMode = CollapseMode.values
        .byName(payload.evalExpr(props.collapseMode) ?? 'parallax');
    final expandedTitleScale =
        payload.evalExpr(props.expandedTitleScale)?.toDouble() ?? 1.5;

    // Cache child widgets for performance
    final cachedTitleWidget = childOf('title')?.toWidget(payload);
    final cachedLeadingWidget = childOf('leading')?.toWidget(payload);
    final cachedBackgroundWidget = childOf('background')?.toWidget(payload);
    final cachedBottomWidget = childOf('bottom')?.toWidget(payload);
    final cachedActionsWidgets = _buildActions(payload);

    Widget? flexibleSpaceWidget;
    if (useFlexibleSpace) {
      flexibleSpaceWidget = FlexibleSpaceBar(
        title: cachedTitleWidget,
        centerTitle: centerTitle,
        titlePadding: titlePadding,
        background: cachedBackgroundWidget,
        collapseMode: collapseMode,
        expandedTitleScale: expandedTitleScale,
      );
    } else if (cachedBackgroundWidget != null) {
      flexibleSpaceWidget = FlexibleSpaceBar(
        background: cachedBackgroundWidget,
      );
    }

    final titleWidget = cachedTitleWidget ??
        VWText(
          props: props.title,
          commonProps: null,
          parent: this,
        ).toWidget(payload);

    return SliverAppBar(
      leading: cachedLeadingWidget,
      automaticallyImplyLeading: showDefaultButton,
      iconTheme: showDefaultButton && defaultButtonColor != null
          ? IconThemeData(color: defaultButtonColor)
          : null,
      titleSpacing: titleSpacing?.toDouble(),
      flexibleSpace: flexibleSpaceWidget,
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      elevation: elevation?.toDouble(),
      snap: snap,
      pinned: pinned,
      floating: floating,
      collapsedHeight: collapsedHeight?.toHeight(payload.buildContext),
      expandedHeight: expandedHeight?.toHeight(payload.buildContext),
      toolbarHeight:
          toolbarHeight?.toHeight(payload.buildContext) ?? kToolbarHeight,
      title: useFlexibleSpace ? null : titleWidget,
      centerTitle: useFlexibleSpace ? false : centerTitle,
      shape: shape,
      bottom: PreferredSize(
        preferredSize: Size(
          bottomSectionWidth?.toWidth(payload.buildContext) ?? 0,
          bottomSectionHeight?.toHeight(payload.buildContext) ?? 0,
        ),
        child: cachedBottomWidget ?? Container(),
      ),
      actions: cachedActionsWidgets,
    );
  }

  List<Widget>? _buildActions(RenderPayload payload) {
    if (childrenOf('actions') == null) return null;

    final actionWidgets = childrenOf('actions');
    if (actionWidgets == null || actionWidgets.isEmpty) return null;

    return actionWidgets.map((widget) => widget.toWidget(payload)).toList();
  }
}
