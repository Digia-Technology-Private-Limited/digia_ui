import 'package:flutter/material.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/widget_util.dart';
import 'icon.dart';
import 'text.dart';

class VWAppBar extends VirtualLeafStatelessWidget<Props> {
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
        props: props.toProps('title') ?? Props.empty(),
        commonProps: null,
        parent: this,
      ).toWidget(payload),
      elevation: payload.eval<double>(props.get('elevation')),
      shadowColor: payload.evalColor(props.get('shadowColor')),
      backgroundColor: payload.evalColor(props.get('backgroundColor')),
      iconTheme: IconThemeData(
        color: payload.evalColor(props.get('iconColor')),
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

    final leadingIconProps = props.toProps('leadingIcon');
    if (leadingIconProps == null) return null;

    var widget = VWIcon(
      props: leadingIconProps,
      commonProps: null,
      parent: this,
    ).toWidget(payload);

    return wrapInGestureDetector(
        payload: payload,
        actionFlow: ActionFlow.fromJson(props.getMap('onTapLeadingIcon')),
        child: widget);
  }

  List<Widget>? _buildActions(RenderPayload payload) {
    if (trailingIcon != null) {
      return [trailingIcon!.toWidget(payload)];
    }

    final trailingIconProps = props.toProps('trailingIcon');
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
