import 'package:flutter/material.dart';

import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../render_payload.dart';
import '../utils/flutter_extensions.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../utils/widget_util.dart';
import '../widget_props/app_bar_props.dart';
import '../widget_props/icon_props.dart';
import 'icon.dart';
import 'text.dart';

class VWAppBar extends VirtualStatelessWidget<AppBarProps> {
  final VirtualWidget? leadingIcon;
  final VirtualWidget? trailingIcon;
  VWAppBar({
    required super.props,
    required super.parent,
    super.refName,
    this.leadingIcon,
    this.trailingIcon,
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
    final useBackgroundWidget =
        payload.evalExpr(props.useBackgroundWidget) ?? false;
    final useTitleWidget = payload.evalExpr(props.useTitleWidget) ?? false;
    final useBottomWidget = payload.evalExpr(props.useBottomWidget) ?? false;
    final automaticallyImplyLeading =
        payload.evalExpr(props.automaticallyImplyLeading) ?? true;
    final defaultButtonColor = payload.evalColorExpr(props.defaultButtonColor);

    Widget? flexibleSpaceWidget;
    if (useFlexibleSpace) {
      flexibleSpaceWidget = childOf('flexibleSpace')?.toWidget(payload) ??
          FlexibleSpaceBar(
            title: _buildTitle(payload, useTitleWidget),
            centerTitle: centerTitle,
            titlePadding: titlePadding,
            background: useBackgroundWidget && childOf('background') != null
                ? childOf('background')!.toWidget(payload)
                : null,
          );
    } else if (useBackgroundWidget && childOf('background') != null) {
      flexibleSpaceWidget = FlexibleSpaceBar(
        background: childOf('background')?.toWidget(payload),
      );
    }

    return AppBar(
      title: useFlexibleSpace ? null : _buildTitle(payload, useTitleWidget),
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
      bottom: useBottomWidget
          ? PreferredSize(
              preferredSize:
                  Size(bottomSectionWidth ?? 0, bottomSectionHeight ?? 0),
              child: childOf('bottom')?.toWidget(payload) ?? Container(),
            )
          : null,
    );
  }

  Widget _buildTitle(RenderPayload payload, bool useTitleWidget) {
    if (useTitleWidget && childOf('title') != null) {
      return childOf('title')!.toWidget(payload);
    }
    return VWText(
      props: props.title,
      commonProps: null,
    ).toWidget(payload);
  }

  Widget? _buildLeading(RenderPayload payload) {
    final useLeadingWidget = payload.evalExpr(props.useLeadingWidget) ?? false;

    if (useLeadingWidget && childOf('leading') != null) {
      return childOf('leading')!.toWidget(payload);
    }

    final leadingIconProps = props.leadingIcon.maybe(IconProps.fromJson);
    if (leadingIconProps == null) return null;

    var widget = VWIcon(
      props: leadingIconProps,
      commonProps: null,
      parent: this,
    ).toWidget(payload);

    return wrapInGestureDetector(
      payload: payload,
      actionFlow: props.onTapLeadingIcon,
      child: widget,
    );
  }

  List<Widget>? _buildActions(RenderPayload payload) {
    final useActionsWidget = payload.evalExpr(props.useActionsWidget) ?? false;

    if (useActionsWidget && childrenOf('actions') != null) {
      return childrenOf('actions')?.map((e) => e.toWidget(payload)).toList();
    }

    final trailingIconProps = props.trailingIcon.maybe(IconProps.fromJson);
    if (trailingIconProps == null) return null;

    return [
      VWIcon(
        props: trailingIconProps,
        commonProps: null,
        parent: this,
      ).toWidget(payload),
    ];
  }
}
