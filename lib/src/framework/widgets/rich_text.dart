import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/types.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import '../widget_props/rich_text_props.dart';

class VWRichText extends VirtualLeafStatelessWidget<RichTextProps> {
  VWRichText({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final textSpans = payload.evalExpr(props.textSpans);
    final spanChildren = _toTextSpan(payload, textSpans);

    if (spanChildren == null || spanChildren.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxLines = payload.evalExpr(props.maxLines);
    final overflow = To.textOverflow(payload.evalExpr(props.overflow));
    final textAlign = To.textAlign(payload.evalExpr(props.alignment));
    final styleJson = props.textStyle;

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

  List<TextSpan>? _toTextSpan(RenderPayload payload, Object? textSpans) {
    if (textSpans == null) return null;

    if (textSpans is String) {
      final value = payload.eval<String>(textSpans);
      return value == null ? null : [TextSpan(text: value)];
    }

    if (textSpans is! List) return null;

    final spanChildren = textSpans
        .cast<Object>()
        .map((span) {
          if (span is String) {
            return TextSpan(
                text: payload.evalExpr(ExprOr.fromJson<String>(span)));
          }

          final spanObject = as$<JsonLike>(span);
          if (spanObject == null) return null;

          final text =
              payload.evalExpr(ExprOr.fromJson<String>(spanObject['text']));
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
