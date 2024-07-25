import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
import '../action/action_handler.dart';
import '../action/action_prop.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIRichTextBuilder extends DUIWidgetBuilder {
  DUIRichTextBuilder({required super.data});

  static DUIRichTextBuilder? create(DUIWidgetJsonData data) {
    return DUIRichTextBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final spanChildren = _toTextSpan(context, data.props['textSpans']);

    if (spanChildren == null || spanChildren.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxLines = eval<int>(data.props['maxLines'], context: context);
    final overflow = DUIDecoder.toTextOverflow(data.props['overflow']);
    final textAlign = DUIDecoder.toTextAlign(data.props['alignment']);
    final styleJson = (data.props['textStyle'] ?? data.props['style'])
        as Map<String, dynamic>?;

    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      text: TextSpan(
        style: ifNotNull(styleJson,
            (p0) => toTextStyle(DUITextStyle.fromJson(styleJson), context)),
        children: spanChildren,
      ),
    );
  }

  List<TextSpan>? _toTextSpan(BuildContext context, dynamic textSpan) {
    if (textSpan == null) return null;

    if (textSpan is String) {
      final value = eval<String>(textSpan, context: context);
      return value == null ? null : [TextSpan(text: value)];
    }

    if (textSpan is! List) return null;

    final spanChildren = textSpan
        .map((span) {
          String? text;
          TextStyle? style;

          if (span is String) {
            text = eval<String>(span, context: context);
            style = null;
          } else {
            text = eval<String>(span['text'], context: context);
            final styleJson =
                span['spanStyle'] ?? span['textStyle'] ?? span['style'];

            style = ifNotNull(styleJson,
                (p0) => toTextStyle(DUITextStyle.fromJson(p0), context));
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
                      await ActionHandler.instance
                          .execute(context: context, actionFlow: onClick);
                    }));
        })
        .nonNulls
        .toList();

    return spanChildren;
  }
}
