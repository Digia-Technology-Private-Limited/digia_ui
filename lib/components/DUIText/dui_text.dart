import 'package:digia_ui/Utils/color_extension.dart';
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
    for (var i = 0; i < props.textSpans.length; i++) {
      list.add(props.textSpans[i].getSpan());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: props.maxLines,
      overflow: props.overFlow != null
          ? props.overFlow!.getOverFlow()
          : TextOverflow.ellipsis,
      textScaleFactor:
          props.textScaleFactor != null ? props.textScaleFactor! : 1,
      textAlign: props.alignment != null
          ? props.alignment!.getTextAlign()
          : TextAlign.start,
      text: TextSpan(
        style: TextStyle(
          fontSize: props.fontSize,
          fontStyle: props.isItalic != null
              ? props.isItalic!
                  ? FontStyle.italic
                  : FontStyle.normal
              : null,
          fontWeight: props.fontWeight != null
              ? props.fontWeight!.getFontWeight()
              : FontWeight.w400,
          color: props.color?.toColor() ?? "2196F3".toColor(),
        ),
        children: getTextSpans(),
      ),
    );
  }
}
