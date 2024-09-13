import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
import '../../core/action/action_handler.dart';
import '../../core/action/action_prop.dart';
import '../render_payload.dart';

import '../stateless_virtual_widget.dart';

class VWRichText extends StatelessVirtualWidget {
  VWRichText(
    super.props, {
    super.commonProps,
    super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final spanChildren = _toTextSpan(payload, props['textSpans']);

    if (spanChildren == null || spanChildren.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxLines = payload.eval<int>(props['maxLines']);
    final overflow =
        DUIDecoder.toTextOverflow(payload.eval<String>(props['overflow']));
    final textAlign =
        DUIDecoder.toTextAlign(payload.eval<String>(props['alignment']));
    final styleJson =
        (props['textStyle'] ?? props['style']) as Map<String, dynamic>?;

    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      text: TextSpan(
        style: ifNotNull(
            styleJson,
            (p0) => toTextStyle(
                DUITextStyle.fromJson(styleJson), payload.buildContext)),
        children: spanChildren,
      ),
    );
  }

  List<TextSpan>? _toTextSpan(RenderPayload payload, dynamic textSpan) {
    if (textSpan == null) return null;

    if (textSpan is String) {
      final value = payload.eval<String>(textSpan);
      return value == null ? null : [TextSpan(text: value)];
    }

    if (textSpan is! List) return null;

    final spanChildren = textSpan
        .map((span) {
          String? text;
          TextStyle? style;

          if (span is String) {
            text = payload.eval<String>(span);
            style = null;
          } else {
            text = payload.eval<String>(span['text']);
            final styleJson =
                span['spanStyle'] ?? span['textStyle'] ?? span['style'];

            style = ifNotNull(
                styleJson,
                (p0) => toTextStyle(
                    DUITextStyle.fromJson(p0), payload.buildContext));
          }

          if (text == null) return null;

          return TextSpan(
              text: text,
              style: style,
              recognizer: ifNotNull(
                  span['onClick'],
                  (p0) => TapGestureRecognizer()
                    ..onTap = () async {
                      final onClick = ActionFlow.fromJson(span['onClick']);
                      await ActionHandler.instance.execute(
                          context: payload.buildContext, actionFlow: onClick);
                    }));
        })
        .nonNulls
        .toList();

    return spanChildren;
  }
}
