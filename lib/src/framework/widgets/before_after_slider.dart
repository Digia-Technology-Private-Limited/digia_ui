import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../widget_props/before_after_slider_props.dart';

class VWBeforeAfterSlider
    extends VirtualStatelessWidget<BeforeAfterSliderProps> {
  VWBeforeAfterSlider({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    required super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    double value = 0.5;
    final beforeChild = childOf('beforeChild');
    final afterChild = childOf('afterChild');
    if (beforeChild == null || afterChild == null) {
      return empty();
    }

    SliderDirection getSliderDirection() {
      switch (payload.evalExpr<String>(props.direction)) {
        case 'horizontal':
          return SliderDirection.horizontal;
        case 'vertical':
          return SliderDirection.vertical;
        default:
          return SliderDirection.horizontal;
      }
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return BeforeAfter(
          height: payload.evalExpr<double>(props.height),
          width: payload.evalExpr<double>(props.width),
          thumbHeight: payload.evalExpr<double>(props.thumbHeight),
          thumbWidth: payload.evalExpr<double>(props.thumbWidth),
          hideThumb: payload.evalExpr<bool>(props.hideThumb) ?? false,
          direction: getSliderDirection(),
          thumbPosition: payload.evalExpr<double>(props.thumbPosition) ?? 0.5,
          thumbColor: payload.evalColorExpr(props.thumbColor),
          value: value,
          onValueChanged: (newValue) {
            setState(() {
              value = newValue;
            });
          },
          trackWidth: payload.evalExpr<double>(props.trackWidth),
          trackColor: payload.evalColorExpr(props.trackColor),
          before: beforeChild.toWidget(payload),
          after: afterChild.toWidget(payload),
        );
      },
    );
  }
}
