import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import '../utils/widget_util.dart';
import '../widget_props/app_bar_props.dart';
import '../widget_props/icon_props.dart';
import 'icon.dart';
import 'text.dart';

class VWAppBar extends VirtualLeafStatelessWidget<AppBarProps> {
  final VirtualWidget? leadingIcon;
  final VirtualWidget? trailingIcon;

  VWAppBar({
    required super.props,
    required super.parent,
    super.refName,
    this.leadingIcon,
    this.trailingIcon,
  }) :
        // Since this is a PrefferedSizeWidget,
        // we shouldn't wrap any Widget around it.
        super(commonProps: null);

  @override
  Widget render(RenderPayload payload) {
    return AppBar(
      title: VWText(
        props: props.title,
        commonProps: null,
      ).toWidget(payload),
      elevation: payload.evalExpr(props.elevation),
      shadowColor: payload.evalColorExpr(props.shadowColor),
      backgroundColor: payload.evalColorExpr(props.backgroundColor),
      iconTheme: IconThemeData(
        color: payload.evalColorExpr(props.iconColor),
      ),
      automaticallyImplyLeading: true,
      leading: _buildLeading(payload),
      actions: _buildActions(payload),
    );
  }

  Widget? _buildLeading(RenderPayload payload) {
    if (leadingIcon != null) {
      return leadingIcon!.toWidget(payload);
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
    if (trailingIcon != null) {
      return [trailingIcon!.toWidget(payload)];
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
