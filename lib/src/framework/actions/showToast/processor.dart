import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:digia_ui/src/framework/custom/border_with_pattern.dart';
import 'package:digia_ui/src/framework/custom/custom_flutter_types.dart';
import 'package:digia_ui/src/framework/models/props.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../expr/scope_context.dart';
import '../../models/types.dart';
import '../../resource_provider.dart';
import '../../utils/flutter_type_converters.dart';
import '../../utils/functional_util.dart';
import '../../utils/num_util.dart';
import '../../utils/textstyle_util.dart';
import '../../utils/types.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class ShowToastProcessor extends ActionProcessor<ShowToastAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ShowToastAction action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    T? evalExpr<T extends Object>(Object? expr) {
      return ExprOr.fromJson<T>(expr)?.evaluate(scopeContext);
    }

    final message = action.message?.evaluate(scopeContext) ?? '';
    final duration = action.duration?.evaluate(scopeContext) ?? 2;

    final JsonLike style = action.style ?? {};

    final Color? bgColor = ExprOr.fromJson<String>(style['bgColor'])
        ?.evaluate(scopeContext)
        .maybe(
            (p0) => ResourceProvider.maybeOf(context)?.getColor(p0, context));
    
    final evalColor = (Object? expr) => ExprOr.fromJson<String>(expr)
        ?.evaluate(scopeContext)
        .maybe(
            (p0) => ResourceProvider.maybeOf(context)?.getColor(p0, context));

    final borderRadius =
        To.borderRadius(style['borderRadius'] ?? '12, 12, 12, 12');
    
    final border = _toBorderWithPattern(
        Props(style).toProps('border') ?? Props.empty(), evalColor);

    final TextStyle? textStyle = makeTextStyle(
      as$<JsonLike>(style['textStyle']),
      context: context,
      eval: evalExpr,
    );
    final height = NumUtil.toDouble(style['height']);
    final width = NumUtil.toDouble(style['width']);

    final padding = To.edgeInsets(style['padding'] ?? '24, 12, 24, 12');
    final margin = To.edgeInsets(style['margin']);
    final alignment = To.alignment(style['alignment']);

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'message': message,
        'duration': duration,
        'style': style,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      observabilityContext: observabilityContext,
    );

    executionContext?.notifyProgress(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      details: {
        'message': message,
        'duration': duration,
        'style': style,
      },
      observabilityContext: observabilityContext,
    );

    try {
      final toast = FToast().init(context);
      toast.showToast(
        child: Container(
          alignment: alignment,
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: bgColor ?? Colors.black,
            borderRadius: borderRadius,
            border: border,
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
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: null,
        stackTrace: null,
        observabilityContext: observabilityContext,
      );
    } catch (e, st) {
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: e,
        stackTrace: st,
        observabilityContext: observabilityContext,
      );
      rethrow;
    }

    executionContext?.notifyComplete(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      error: null,
      stackTrace: null,
      observabilityContext: observabilityContext,
    );

    return null;
  }
}

BorderWithPattern? _toBorderWithPattern(
  Props props,
  Color? Function(Object? expr) evalColor,
) {
  if (props.isEmpty) return null;

  final strokeWidth = props.getDouble('borderWidth') ?? 0;

  if (strokeWidth <= 0) return null;

  final borderColor = evalColor(props.get('borderColor')) ?? Colors.transparent;
  final dashPattern =
      To.dashPattern(props.get('borderType.dashPattern')) ?? const [3, 1];
  final strokeCap =
      To.strokeCap(props.get('borderType.strokeCap')) ?? StrokeCap.butt;
  final borderGradiant =
      To.gradient(props.getMap('borderGradiant'), evalColor: evalColor);

  final BorderPattern borderPattern =
      To.borderPattern(props.get('borderType.borderPattern')) ??
          BorderPattern.solid;
  final strokeAlign =
      To.strokeAlign(props.get('strokeAlign')) ?? StrokeAlign.center;

  return BorderWithPattern(
    strokeWidth: strokeWidth,
    color: borderColor,
    dashPattern: dashPattern,
    strokeCap: strokeCap,
    gradient: borderGradiant,
    borderPattern: borderPattern,
    strokeAlign: strokeAlign,
  );
}
