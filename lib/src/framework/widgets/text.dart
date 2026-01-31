import 'package:flutter/material.dart';
import 'package:widget_marquee/widget_marquee.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/types.dart';
import '../widget_props/text_props.dart';

class VWText extends VirtualLeafStatelessWidget<TextProps> {
  VWText({
    required super.props,
    required super.commonProps,
    super.parentProps,
    super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final text = payload.evalExpr(props.text);
    final style = payload.getTextStyle(props.textStyle);
    final maxLines = payload.evalExpr(props.maxLines);
    final alignment = To.textAlign(payload.evalExpr(props.alignment));
    final overflow = payload.evalExpr(props.overflow);

    final gradientConfig = props.textStyle != null
        ? payload.eval<JsonLike>(props.textStyle!['gradient'])
        : null;
    final gradient = gradientConfig != null
        ? To.gradient(
            gradientConfig as Map<String, Object?>?,
            evalColor: (colorRef) => payload.evalColor(colorRef),
          )
        : null;

    Widget textWidget;
    if (gradient != null) {
      textWidget = ShaderMask(
        shaderCallback: (bounds) => gradient.createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: Text(
          text.toString(),
          style: style?.copyWith(color: Colors.white),
          maxLines: maxLines,
          overflow: To.textOverflow(overflow),
          textAlign: alignment,
        ),
      );
    } else {
      textWidget = Text(
        text.toString(),
        style: style,
        maxLines: maxLines,
        overflow: To.textOverflow(overflow),
        textAlign: alignment,
      );
    }

    if (overflow == 'marquee') {
      return Marquee(
        pause: Duration.zero,
        delay: Duration.zero,
        duration: const Duration(seconds: 11),
        gap: 100,
        child: textWidget,
      );
    }

    return textWidget;
  }
}
