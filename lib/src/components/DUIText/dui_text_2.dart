import 'package:flutter/material.dart';

import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/DUIText/dui_text_style.dart';

class DUIText2 extends StatelessWidget {
  final String? data;
  final String? overflow;
  final int? maxLines;
  final String? textAlign;
  final DUITextStyle? textStyle;

  const DUIText2({
    super.key,
    this.data,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(data ?? '',
        style: toTextStyle(textStyle),
        maxLines: maxLines,
        overflow: DUIDecoder.toTextOverflow(overflow),
        textAlign: DUIDecoder.toTextAlign(textAlign));
  }
}
