import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../expr/scope_context.dart';
import '../../models/types.dart';
import '../../resource_provider.dart';
import '../../utils/flutter_type_converters.dart';
import '../../utils/functional_util.dart';
import '../../utils/textstyle_util.dart';
import '../../utils/types.dart';
import '../base/processor.dart';
import 'action.dart';

class ShowToastProcessor extends ActionProcessor<ShowToastAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ShowToastAction action,
    ScopeContext? scopeContext,
  ) async {
    T? evalExpr<T extends Object>(Object? expr) {
      return ExprOr.fromJson<T>(expr)?.evaluate(scopeContext);
    }

    final message = action.message?.evaluate(scopeContext) ?? '';
    final duration = action.duration?.evaluate(scopeContext) ?? 2;

    final JsonLike style = action.style ?? {};

    final Color? bgColor = ExprOr.fromJson<String>(style['bgColor'])
        ?.evaluate(scopeContext)
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

    logAction(
      action.actionType.value,
      {
        'message': message,
        'duration': duration,
        'style': style,
      },
    );

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
