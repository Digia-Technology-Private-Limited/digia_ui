import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/components/DUIText/dui_text_style.dart';
import 'package:digia_ui/src/components/dui_widget_scope.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';

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

    final eval = DUIWidgetScope.of(context)!.eval;

    final maxLines = eval<int>(data.props['maxLines']);
    final overflow = DUIDecoder.toTextOverflow(data.props['overflow']);
    final textAlign = DUIDecoder.toTextAlign(data.props['textAlign']);
    final styleJson = (data.props['textStyle'] ?? data.props['style']) as Map<String, dynamic>?;

    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      text: TextSpan(
        style: ifNotNull(styleJson, (p0) => toTextStyle(DUITextStyle.fromJson(styleJson))),
        children: spanChildren,
      ),
    );
  }

  List<TextSpan>? _toTextSpan(BuildContext context, dynamic textSpan) {
    final eval = DUIWidgetScope.of(context)!.eval;
    if (textSpan == null) return null;

    if (textSpan is String) {
      final value = eval<String>(textSpan);
      return value == null ? null : [TextSpan(text: value)];
    }

    if (textSpan is! List) return null;

    final spanChildren = textSpan
        .map((span) {
          String? text;
          TextStyle? style;

          if (span is String) {
            text = eval<String>(span);
            style = null;
          } else {
            text = eval<String>(span['text']);
            final styleJson = span['spanStyle'] ?? span['textStyle'] ?? span['style'];

            style = ifNotNull(styleJson, (p0) => toTextStyle(DUITextStyle.fromJson(p0)));
          }

          if (text == null) return null;

          return TextSpan(text: text, style: style);
        })
        .nonNulls
        .toList();

    return spanChildren;
  }
}
