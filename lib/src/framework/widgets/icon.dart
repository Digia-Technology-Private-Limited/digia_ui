import 'package:flutter/widgets.dart';

import '../../components/dui_icons/icon_helpers/icon_data_serialization.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';
import '../widget_props/icon_props.dart';

class VWIcon extends VirtualLeafStatelessWidget<IconProps> {
  VWIcon({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    var iconData = payload.getIcon(props.iconData);

    iconData ??= getIconData(icondataMap: props.iconData);

    final iconSize = payload.evalExpr(props.size);
    final iconColor = payload.evalColorExpr(props.color);

    return Icon(
      iconData,
      size: iconSize,
      color: iconColor,
    );
  }
}
