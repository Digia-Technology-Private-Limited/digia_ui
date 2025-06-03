import 'package:flutter/material.dart';

import '../base/virtual_sliver.dart';
import '../render_payload.dart';
import '../utils/flutter_extensions.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/sliver_app_bar_props.dart';
import 'image.dart';
import 'text.dart';

class VWSliverAppBar extends VirtualSliver<SliverAppBarProps> {
  VWSliverAppBar({
    required super.props,
    required super.commonProps,
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
    final useBackgroundWidget =
        payload.evalExpr(props.useBackgroundWidget) ?? false;

    final pinned = payload.evalExpr(props.pinned) ?? true;
    final floating = payload.evalExpr(props.floating) ?? false;
    final snap = payload.evalExpr(props.snap) ?? false;

    final useBottomWidget = payload.evalExpr(props.useBottomWidget) ?? false;
    final bottomSectionHeight = payload.evalExpr(props.bottomSectionHeight);
    final bottomSectionWidth = payload.evalExpr(props.bottomSectionWidth);

    final showDefaultButton =
        payload.evalExpr(props.automaticallyImplyLeading) ?? true;
    final defaultButtonColor = payload.evalColor(props.defaultButtonColor);

    final shape = To.buttonShape(props.shape, payload.getColor);

    Widget? flexibleSpaceWidget;
    if (useFlexibleSpace) {
      flexibleSpaceWidget = FlexibleSpaceBar(
        title: childOf('title')?.toWidget(payload),
        centerTitle: centerTitle,
        titlePadding: titlePadding,
        background: useBackgroundWidget && props.backgroundImage != null
            ? _buildBackgroundImage(payload)
            : null,
      );
    } else if (useBackgroundWidget && props.backgroundImage != null) {
      flexibleSpaceWidget = FlexibleSpaceBar(
        background: _buildBackgroundImage(payload),
      );
    }

    final useTitleWidget = payload.evalExpr(props.useTitleWidget) ?? false;
    final titleWidget = useTitleWidget
        ? childOf('title')?.toWidget(payload)
        : VWText(
            props: props.title,
            commonProps: null,
            parent: this,
          ).toWidget(payload);

    return SliverAppBar(
      leading: childOf('leading')?.toWidget(payload),
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
      bottom: useBottomWidget && bottomSectionHeight != null
          ? PreferredSize(
              preferredSize: Size(
                  bottomSectionWidth?.toWidth(payload.buildContext) ?? 0,
                  bottomSectionHeight.toHeight(payload.buildContext) ?? 0),
              child: childOf('bottom')?.toWidget(payload) ?? Container(),
            )
          : null,
      actions: _buildActions(payload),
    );
  }

  List<Widget>? _buildActions(RenderPayload payload) {
    final useActionsWidget = payload.evalExpr(props.useActionsWidget) ?? false;
    if (!useActionsWidget) return null;

    final actionWidgets = childrenOf('actions');
    if (actionWidgets == null || actionWidgets.isEmpty) return null;

    return actionWidgets.map((widget) => widget.toWidget(payload)).toList();
  }

  Widget? _buildBackgroundImage(RenderPayload payload) {
    if (props.backgroundImage == null) return null;

    final imageSrc = payload.eval<String>(props.backgroundImage!['imageSrc']);
    final imageFit = payload.eval<String>(props.backgroundImage!['imageFit']);

    return VWImage.fromValues(
      imageSrc: imageSrc,
      imageFit: imageFit,
    ).toWidget(payload);
  }
}
