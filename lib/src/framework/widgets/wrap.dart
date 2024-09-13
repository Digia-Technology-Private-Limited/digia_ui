import 'package:flutter/widgets.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/extensions.dart';
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
    final children = childrenOf('children');

    return Wrap(
      spacing: payload.eval<double>(props['spacing']) ?? 0,
      alignment: DUIDecoder.toWrapAlignment(
          payload.eval<String>(props['wrapAlignment'])),
      crossAxisAlignment: DUIDecoder.toWrapCrossAlignment(
          payload.eval<String>(props['wrapCrossAlignment'])),
      direction: DUIDecoder.toAxis(payload.eval<String>(props['direction'])),
      runSpacing: payload.eval<double>(props['runSpacing']) ?? 0,
      runAlignment: DUIDecoder.toWrapAlignment(
          payload.eval<String>(props['runAlignment'])),
      verticalDirection: DUIDecoder.toVerticalDirection(
          payload.eval<String>(props['verticalDirection'])),
      clipBehavior:
          DUIDecoder.toClip(payload.eval<String>(props['clipBehavior'])),
      children: !children.isNullOrEmpty
          ? children!.map((child) => child.toWidget(payload)).toList()
          : [
              const Text(
                'Children field is Empty!',
                textAlign: TextAlign.center,
              ),
            ],
    );
  }
}
