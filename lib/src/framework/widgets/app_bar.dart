import 'package:flutter/material.dart';
import '../../Utils/util_functions.dart';
import '../../components/dui_widget_creator_fn.dart';
import '../../core/action/action_prop.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../core/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import 'icon.dart';
import 'text.dart';

class VWAppBar extends VirtualLeafStatelessWidget {
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
      shadowColor: makeColor(payload.eval<String>(props.get('shadowColor'))),
      backgroundColor:
          makeColor(payload.eval<String>(props.get('backgroundColor'))),
      iconTheme: IconThemeData(
        color: makeColor(payload.eval<String>(props.get('iconColor'))),
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

    return DUIGestureDetector(
        context: payload.buildContext,
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
