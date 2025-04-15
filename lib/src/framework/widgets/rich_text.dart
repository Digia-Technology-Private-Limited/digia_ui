import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';

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
        .cast<Object>()
        .map((span) {
          if (span is String) {
            return TextSpan(text: payload.eval<String>(span));
          }

          final spanObject = as$<JsonLike>(span);
          if (spanObject == null) return null;

          final text = payload.eval<String>(spanObject['text']);
          final styleJson = tryKeys<JsonLike>(
            spanObject,
            ['spanStyle', 'textStyle', 'style'],
          );

          final style = payload.getTextStyle(styleJson);

          return TextSpan(
              text: text,
              style: style,
              recognizer: spanObject['onClick'].maybe(
                (p0) => TapGestureRecognizer()
                  ..onTap = () {
                    final onClick = ActionFlow.fromJson(p0);
                    payload.executeAction(onClick);
                  },
              ));
        })
        .nonNulls
        .toList();

    return spanChildren;
  }
}
