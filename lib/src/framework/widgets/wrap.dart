import 'package:flutter/widgets.dart';
import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

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
      alignment:
          To.wrapAlignment(payload.eval<String>(props.get('wrapAlignment'))) ??
              WrapAlignment.start,
      crossAxisAlignment: To.wrapCrossAlignment(
              payload.eval<String>(props.get('wrapCrossAlignment'))) ??
          WrapCrossAlignment.start,
      direction: To.axis(payload.eval<String>(props.get('direction'))) ??
          Axis.horizontal,
      runSpacing: payload.eval<double>(props.get('runSpacing')) ?? 0,
      runAlignment:
          To.wrapAlignment(payload.eval<String>(props.get('runAlignment'))) ??
              WrapAlignment.start,
      verticalDirection: To.verticalDirection(
              payload.eval<String>(props.get('verticalDirection'))) ??
          VerticalDirection.down,
      clipBehavior:
          To.clip(payload.eval<String>(props.get('clipBehavior'))) ?? Clip.none,
      children: children!.toWidgetArray(payload),
    );
  }
}
