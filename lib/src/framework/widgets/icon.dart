import 'package:flutter/widgets.dart';

import '../../Utils/util_functions.dart';
import '../../components/dui_icons/icon_helpers/icon_data_serialization.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';

class VWIcon extends VirtualLeafStatelessWidget {
  VWIcon({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final iconConfig = props.getMap('iconData');
    if (iconConfig == null) return empty();

    var iconData = payload.getIcon(iconConfig);

    iconData ??= getIconData(icondataMap: iconConfig);

    final iconSize = payload.eval<double>(props.get('iconSize'));
    final iconColor = makeColor(
      payload.eval<String>(props.get('iconColor')),
    );

    return Icon(
      iconData,
      size: iconSize,
      color: iconColor,
    );
  }
}
