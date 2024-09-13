import 'package:flutter/widgets.dart';

import '../../Utils/util_functions.dart';
import '../../components/dui_icons/icon_helpers/icon_data_serialization.dart';
import '../../components/dui_widget_scope.dart';
import '../render_payload.dart';

import '../stateless_virtual_widget.dart';

class VWIcon extends StatelessVirtualWidget {
  VWIcon(
    super.props, {
    super.commonProps,
    super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    if (props['iconData'] == null) {
      return const SizedBox.shrink();
    }

    final scope = DUIWidgetScope.maybeOf(payload.buildContext);
    var iconData = scope?.iconDataProvider?.call(props['iconData']);

    iconData ??= getIconData(icondataMap: props['iconData']);

    return Icon(
      iconData,
      size: payload.eval<double>(props['iconSize']),
      color: makeColor(
        payload.eval<String>(props['iconColor']),
      ),
    );
  }
}
