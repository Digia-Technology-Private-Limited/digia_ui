import 'package:flutter/widgets.dart';
import 'package:widget_marquee/widget_marquee.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';

class VWText extends VirtualLeafStatelessWidget {
  VWText({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final text = payload.eval<String>(props['text']);
    final style = toTextStyle(
        DUITextStyle.fromJson(props['textStyle']), payload.buildContext);
    final maxLines = payload.eval<int>(props['maxLines']);
    final textAlign = DUIDecoder.toTextAlign(payload.eval(props['alignment']));

    if (props['overflow'] == 'marquee') {
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
        DUIDecoder.toTextOverflow(payload.eval<String>(props['overflow']));
    return Text(
      text.toString(),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
