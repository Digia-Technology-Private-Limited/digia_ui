import 'package:flutter/material.dart';
import 'package:widget_marquee/widget_marquee.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

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
    return _DUIText(props: data.props);
  }
}

class _DUIText extends StatelessWidget {
  final Map<String, dynamic> props;

  const _DUIText({
    Key? key,
    required this.props,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = eval<String>(props['text'], context: context);
    final style =
        toTextStyle(DUITextStyle.fromJson(props['textStyle']), context);
    final maxLines = eval<int>(props['maxLines'], context: context);
    final textAlign = DUIDecoder.toTextAlign(props['alignment']);
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
    final overflow = DUIDecoder.toTextOverflow(props['overflow']);
    return Text(text.toString(),
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign);
  }
}
