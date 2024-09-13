import 'package:flutter/widgets.dart';

import '../../Utils/util_functions.dart';
import '../../components/dui_icons/icon_helpers/icon_data_serialization.dart';
import '../../components/dui_widget_scope.dart';
import '../core/virtual_leaf_stateless_widget.dart';
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
    if (props.get('iconData') == null) {
      return const SizedBox.shrink();
    }

    // TODO: Probably re-think this.
    final scope = DUIWidgetScope.maybeOf(payload.buildContext);
    var iconData = scope?.iconDataProvider?.call(props.getMap('iconData'));

    iconData ??= getIconData(icondataMap: props.getMap('iconData'));

    return Icon(
      iconData,
      size: payload.eval<double>(props.get('iconSize')),
      color: makeColor(
        payload.eval<String>(props.get('iconColor')),
      ),
    );
  }
}
