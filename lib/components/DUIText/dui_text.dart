import 'package:digia_ui/Utils/color_extension.dart';
import 'package:digia_ui/Utils/constants.dart';
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
      overflow: props.overFlow?.getOverFlow() ?? TextOverflow.ellipsis,
      textScaleFactor: props.textScaleFactor ?? 1,
      textAlign: props.alignment?.getTextAlign() ?? TextAlign.start,
      text: TextSpan(
        style: TextStyle(
          fontSize: props.fontSize,
          fontStyle:
              (props.isItalic ?? false) ? FontStyle.italic : FontStyle.normal,
          fontWeight: props.fontWeight?.getFontWeight() ?? FontWeight.w400,
          color: props.color?.toColor() ?? kHexBlack.toColor(),
        ),
        children: getTextSpans(),
      ),
    );
  }
}
