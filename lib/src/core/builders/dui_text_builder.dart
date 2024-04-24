import 'package:digia_ui/src/components/dui_widget_scope.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';

class DUITextBuilder extends DUIWidgetBuilder {
  DUITextBuilder({required super.data});

  static DUITextBuilder? create(DUIWidgetJsonData data) {
    return DUITextBuilder(data: data);
  }

  factory DUITextBuilder.fromProps({required Map<String, dynamic>? props}) {
    return DUITextBuilder(
        data: DUIWidgetJsonData(type: 'digia/text', props: props));
  }

  @override
  Widget build(BuildContext context) {
    final eval = DUIWidgetScope.of(context)!.eval;
    final text = eval<String>(data.props['text']);
    final style = toTextStyle(DUITextStyle.fromJson(data.props['textStyle']));
    final maxLines = eval<int>(data.props['maxLines']);
    final overflow = DUIDecoder.toTextOverflow(data.props['overflow']);
    final textAlign = DUIDecoder.toTextAlign(data.props['textAlign']);

    return Text(text.toString(),
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign);
  }
}
