import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../render_payload.dart';
import '../widget_props/positioned_props.dart';

class VWPositioned extends VirtualStatelessWidget<PositionedProps> {
  VWPositioned({
    required super.props,
    required super.parent,
    super.refName,
    required VirtualWidget child,
  }) : super(
          commonProps: null,
          childGroups: {
            'child': [child],
          },
        );

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();
    if (props.expr != null) {
      final Object? raw = payload.evalExpr(props.expr);

      if (raw != null) {
        List<num> values = [];

        if (raw is List) {
          if (raw.length == 1 && raw.first is String) {
            values = (raw.first as String)
                .split(',')
                .map((e) => num.tryParse(e.trim()))
                .whereType<num>()
                .toList();
          } else {
            values = raw
                .map((e) => e is num ? e : num.tryParse(e.toString()))
                .whereType<num>()
                .toList();
          }
        } else if (raw is String) {
          values = raw
              .split(',')
              .map((e) => num.tryParse(e.trim()))
              .whereType<num>()
              .toList();
        }

        if (values.length >= 4) {
          return Positioned(
            left: values[0].toDouble(),
            top: values[1].toDouble(),
            right: values[2].toDouble(),
            bottom: values[3].toDouble(),
            child: child!.toWidget(payload),
          );
        }
      }
    }

    return Positioned(
      left: payload.evalExpr(props.left),
      top: payload.evalExpr(props.top),
      right: payload.evalExpr(props.right),
      bottom: payload.evalExpr(props.bottom),
      width: payload.evalExpr(props.width),
      height: payload.evalExpr(props.height),
      child: child!.toWidget(payload),
    );
  }
}
