import 'package:flutter/widgets.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../components/utils/DUIInsets/dui_insets.dart';
import '../base/extensions.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';
import 'positioned.dart';

class VWStack extends VirtualStatelessWidget {
  VWStack(
      {required super.props,
      required super.commonProps,
      required super.childGroups,
      required super.parent,
      super.refName})
      : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    return Stack(
        alignment:
            DUIDecoder.toStackChildAlignment(props.getString('childAlignment')),
        fit: DUIDecoder.toStackFit(props.get('fit')),
        children: children!
            .map(_wrapInPositionedForBackwardCompat)
            .toWidgetArray(payload));
  }

  // This is for backward compatibility:
  VirtualWidget _wrapInPositionedForBackwardCompat(
      VirtualWidget childVirtualWidget) {
    // Ignore if widget is already wrapped in Positioned
    if (childVirtualWidget is! VirtualLeafStatelessWidget ||
        childVirtualWidget is VWPositioned) {
      return childVirtualWidget;
    }

    final position = as$<JsonLike>(childVirtualWidget.commonProps?.parentProps
            ?.get('positioned.position'))
        .maybe(DUIInsets.fromJson)
        ?.toJson();

    final hasPosition = childVirtualWidget.commonProps?.parentProps
            ?.getBool('positioned.hasPosition') ??
        false;
    if (!hasPosition || position == null) return childVirtualWidget;

    return VWPositioned.fromValues(
      position: position,
      child: childVirtualWidget,
      parent: this,
    );
  }
}
