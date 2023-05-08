import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/DUIText/dui_text_props.dart';
import 'package:flutter/material.dart';

class DUIText extends StatefulWidget {
  final DUITextProps props;

  const DUIText(this.props, {super.key}) : super();

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

  List<TextSpan> getTextSpans() {
    List<TextSpan> list = [];
    for (var i in props.textSpans) {
      list.add(i.getSpan());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: props.maxLines,
      overflow: getOverFlow(props.overFlow ?? ""),
      textAlign: getTextAlign(props.alignment ?? ""),
      text: TextSpan(
        style: getTextStyle(style: props.style),
        children: getTextSpans(),
      ),
    );
  }
}
