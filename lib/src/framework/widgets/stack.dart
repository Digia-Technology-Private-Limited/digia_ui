import 'package:flutter/widgets.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../components/utils/DUIInsets/dui_insets.dart';
import '../core/extensions.dart';
import '../core/virtual_stateless_widget.dart';
import '../core/virtual_widget.dart';
import '../render_payload.dart';
import 'positioned.dart';

class VWStack extends VirtualStatelessWidget {
  VWStack({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    required super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    return _buildStack(
        () => children!.map(_wrapInPositioned).toWidgetArray(payload));
  }

  // This is for backward compatibility:
  VirtualWidget _wrapInPositioned(VirtualWidget childVirtualWidget) {
    // Ignore if widget is already wrapped in Positioned
    if (childVirtualWidget is! VirtualStatelessWidget ||
        childVirtualWidget is VWPositioned) {
      return childVirtualWidget;
    }

    final position = DUIInsets.fromJson(
        childVirtualWidget.commonProps?.get('positioned.position') ?? {});
    final hasPosition =
        childVirtualWidget.commonProps?.getBool('positioned.hasPosition') ??
            false;
    if (!hasPosition) return childVirtualWidget;

    return VWPositioned.fromValues(
      position: position,
      child: childVirtualWidget,
      parent: this,
    );
  }

  Widget _buildStack(List<Widget> Function() childrenBuilder) {
    return Stack(
      alignment:
          DUIDecoder.toStackChildAlignment(props.getString('childAlignment')),
      fit: DUIDecoder.toStackFit(props.getString('fit')),
      children: childrenBuilder(),
    );
  }
}
