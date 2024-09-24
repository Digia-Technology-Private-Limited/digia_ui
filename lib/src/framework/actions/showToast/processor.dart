import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/types.dart';
import '../../page/resource_provider.dart';
import '../../utils/flutter_type_converters.dart';
import '../../utils/functional_util.dart';
import '../../utils/textstyle_util.dart';
import '../../utils/types.dart';
import '../base/processor.dart';
import 'action.dart';

class ShowToastProcessor implements ActionProcessor<ShowToastAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ShowToastAction action,
    ExprContext? exprContext,
  ) async {
    T? evalExpr<T extends Object>(Object? expr) {
      return ExprOr.fromJson<T>(expr)?.evaluate(exprContext);
    }

    final message = action.message?.evaluate(exprContext) ?? '';
    final duration = action.duration?.evaluate(exprContext) ?? 2;

    final JsonLike style = action.style ?? {};

    final Color? bgColor = ExprOr.fromJson<String>(style['bgColor'])
        ?.evaluate(exprContext)
        .maybe((p0) => ResourceProvider.maybeOf(context)?.getColor(p0));
    final borderRadius =
        To.borderRadius(style['borderRadius'] ?? '12, 12, 12, 12');

    final TextStyle? textStyle = makeTextStyle(
      as$<JsonLike>(style['textStyle']),
      context: context,
      eval: evalExpr,
    );
    final height = style['height'] as double?;
    final width = style['width'] as double?;
    final padding = To.edgeInsets(style['padding'] ?? '24, 12, 24, 12');
    final margin = To.edgeInsets(style['margin']);
    final alignment = To.alignment(style['alignment']);

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
