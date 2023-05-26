import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/DUIText/dui_text_props.dart';
import 'package:flutter/material.dart';

class DUIText extends StatefulWidget {
  final DUITextProps props;

  const DUIText(this.props, {super.key}) : super();

  factory DUIText.create(Map<String, dynamic> json) =>
      DUIText(DUITextProps.fromJson(json));

  @override
  State<DUIText> createState() => _DUITextState();
}

class _DUITextState extends State<DUIText> {
  late DUITextProps props;

  _DUITextState();

  @override
  void initState() {
    props = widget.props;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mayNotUseRichText = props.textSpans.length == 1;

    final overflow = toTextOverflow(props.overflow);
    final maxLines = props.maxLines;
    final textAlign = toTextAlign(props.alignment);

    if (mayNotUseRichText) {
      final text = props.textSpans[0].text;
      final style = props.textSpans[0].styleClass ?? props.styleClass;

      return Text(text,
          style: toTextStyle(style),
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign);
    }

    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      text: TextSpan(
        style: toTextStyle(props.styleClass),
        children: props.textSpans.map(toTextSpan).toList(),
      ),
    );
  }
}
