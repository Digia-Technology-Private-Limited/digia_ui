import 'package:flutter/widgets.dart';
import 'package:widget_marquee/widget_marquee.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWText extends VirtualLeafStatelessWidget {
  VWText({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final text = payload.eval<String>(props.get('text'));
    final style = payload.getTextStyle(props.getMap('textStyle'));
    final maxLines = payload.eval<int>(props.get('maxLines'));
    final textAlign = To.textAlign(payload.eval(props.get('alignment')));

    if (props.get('overflow') == 'marquee') {
      return Marquee(
        pause: Duration.zero,
        delay: Duration.zero,
        duration: const Duration(seconds: 11),
        gap: 100,
        child: Text(text.toString(),
            style: style, maxLines: maxLines, textAlign: textAlign),
      );
    }

    final overflow =
        To.textOverflow(payload.eval<String>(props.get('overflow')));
    return Text(
      text.toString(),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
