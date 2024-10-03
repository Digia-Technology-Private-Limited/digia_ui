import 'package:flutter/widgets.dart';
import 'package:widget_marquee/widget_marquee.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/text_props.dart';

class VWText extends VirtualLeafStatelessWidget<TextProps> {
  VWText({
    required super.props,
    required super.commonProps,
    super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final text = payload.evalExpr(props.text);
    final style = payload.getTextStyle(props.textStyle);
    final maxLines = payload.evalExpr(props.maxLines);
    final alignment = To.textAlign(props.alignment);

    final overflow = payload.evalExpr(props.overflow);

    if (overflow == 'marquee') {
      return Marquee(
        pause: Duration.zero,
        delay: Duration.zero,
        duration: const Duration(seconds: 11),
        gap: 100,
        child: Text(text.toString(),
            style: style, maxLines: maxLines, textAlign: alignment),
      );
    }

    return Text(
      text.toString(),
      style: style,
      maxLines: maxLines,
      overflow: To.textOverflow(overflow),
      textAlign: alignment,
    );
  }
}
