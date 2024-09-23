import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../../Utils/util_functions.dart';
import '../../../components/DUIText/dui_text_style.dart';
import '../base/processor.dart';
import 'action.dart';

class ShowToastProcessor implements ActionProcessor<ShowToastAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ShowToastAction action,
    ExprContext? exprContext,
  ) async {
    final message = action.message?.evaluate(exprContext) ?? '';
    final duration = action.duration?.evaluate(exprContext) ?? 2;

    final Map<String, dynamic> style = action.style ?? {};

    final Color? bgColor = makeColor(style['bgColor']);
    final borderRadius =
        DUIDecoder.toBorderRadius(style['borderRadius'] ?? '12, 12, 12, 12');
    final TextStyle? textStyle =
        toTextStyle(DUITextStyle.fromJson(style['textStyle']), context);
    final height = style['height'] as double?;
    final width = style['width'] as double?;
    final padding =
        DUIDecoder.toEdgeInsets(style['padding'] ?? '24, 12, 24, 12');
    final margin = DUIDecoder.toEdgeInsets(style['margin']);
    final alignment = DUIDecoder.toAlignment(style['alignment']);

    final toast = FToast().init(context);
    toast.showToast(
      child: Container(
        alignment: alignment,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.black,
          borderRadius: borderRadius,
        ),
        padding: padding,
        margin: margin,
        child: Text(
          message,
          style: textStyle ?? const TextStyle(color: Colors.white),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: duration),
    );

    return null;
  }
}
