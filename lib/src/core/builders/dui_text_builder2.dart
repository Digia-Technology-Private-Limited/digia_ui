import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/expr.dart';
import 'package:flutter/material.dart';

import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/DUIText/dui_text_style.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';

class DUIText2Builder extends DUIWidgetBuilder {
  DUIText2Builder({required super.data});

  static DUIText2Builder? create(DUIWidgetJsonData data) {
    return DUIText2Builder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final text = evaluateExpression<String>(
        data.props['text'], context, (p0) => p0 as String?);
    final style = toTextStyle(DUITextStyle.fromJson(data.props['textStyle']));
    final maxLines = evaluateExpression<int>(
        data.props['maxLines'], context, (p0) => p0 as int?);
    final overflow = DUIDecoder.toTextOverflow(data.props['overflow']);
    final textAlign = DUIDecoder.toTextAlign(data.props['textAlign']);

    return Text(text ?? '',
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign);
  }
}
