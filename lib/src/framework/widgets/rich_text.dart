import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';

class VWRichText extends VirtualLeafStatelessWidget<Props> {
  VWRichText({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final spanChildren = _toTextSpan(payload, props.get('textSpans'));

    if (spanChildren == null || spanChildren.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxLines = payload.eval<int>(props.get('maxLines'));
    final overflow =
        To.textOverflow(payload.eval<String>(props.get('overflow')));
    final textAlign =
        To.textAlign(payload.eval<String>(props.get('alignment')));
    final styleJson = props.getMap('textStyle') ?? props.getMap('style');

    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      text: TextSpan(
        style: payload.getTextStyle(styleJson),
        children: spanChildren,
      ),
    );
  }

  List<TextSpan>? _toTextSpan(RenderPayload payload, Object? textSpan) {
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

            style = payload.getTextStyle(styleJson);
          }

          if (text == null) return null;
          return TextSpan(
              text: text,
              style: style,
              recognizer: (span['onClick'] as Object?)
                  .maybe((p0) => TapGestureRecognizer()
                    ..onTap = () {
                      final onClick = ActionFlow.fromJson(span['onClick']);
                      payload.executeAction(onClick);
                    }));
        })
        .nonNulls
        .toList();

    return spanChildren;
  }
}
