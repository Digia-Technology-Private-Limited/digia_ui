import 'package:flutter/widgets.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../core/extensions.dart';
import '../core/virtual_stateless_widget.dart';
import '../render_payload.dart';

class VWWrap extends VirtualStatelessWidget {
  VWWrap({
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

    return Wrap(
      spacing: payload.eval<double>(props.get('spacing')) ?? 0,
      alignment: DUIDecoder.toWrapAlignment(
          payload.eval<String>(props.get('wrapAlignment'))),
      crossAxisAlignment: DUIDecoder.toWrapCrossAlignment(
          payload.eval<String>(props.get('wrapCrossAlignment'))),
      direction:
          DUIDecoder.toAxis(payload.eval<String>(props.get('direction'))),
      runSpacing: payload.eval<double>(props.get('runSpacing')) ?? 0,
      runAlignment: DUIDecoder.toWrapAlignment(
          payload.eval<String>(props.get('runAlignment'))),
      verticalDirection: DUIDecoder.toVerticalDirection(
          payload.eval<String>(props.get('verticalDirection'))),
      clipBehavior:
          DUIDecoder.toClip(payload.eval<String>(props.get('clipBehavior'))),
      children: children!.toWidgetArray(payload),
    );
  }
}
