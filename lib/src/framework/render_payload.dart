import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../network/api_request/api_request.dart';
import 'actions/base/action_flow.dart';
import 'models/vw_repeat_data.dart';
import 'page/resource_provider.dart';
import 'ui_factory.dart';
import 'utils/expression_util.dart';

class RenderPayload {
  final BuildContext buildContext;
  final ExprContext exprContext;

  RenderPayload({required this.buildContext, required this.exprContext});

  // Retrieves an icon from a map, currently not implemented
  IconData? getIcon(Map<String, Object?>? map) {
    if (map == null) return null;

    // TODO: Yet to be implemented
    return null;
  }

  // Retrieves a color from the ResourceProvider using a key
  Color? getColor(String key) {
    return ResourceProvider.maybeOf(buildContext)?.getColor(key);
  }

  // Retrieves an API model from the ResourceProvider using an ID
  APIModel? getApiModel(String id) {
    return ResourceProvider.maybeOf(buildContext)?.apiModels[id];
  }

  // Executes an action flow with an optional expression context
  Future<Object?>? executeAction(
    ActionFlow actionFlow, {
    ExprContext? exprContext,
  }) {
    return DefaultActionExecutor.of(buildContext).execute(
      buildContext,
      actionFlow,
      _chainExprContext(exprContext),
    );
  }

  // Evaluates an expression with an optional chained expression context
  T? eval<T extends Object>(Object? expression,
      {ExprContext? exprContext, T? Function(Object?)? decoder}) {
    return evaluate<T>(
      expression,
      exprContext: _chainExprContext(exprContext),
      decoder: decoder,
    );
  }

  // Evaluates and retrieves repeatable data
  List<Object> evalRepeatData(VWRepeatData data) {
    if (data.isJson) {
      return data.toJsonArray() ?? [];
    }

    return eval<List>(
          data.datum,
          decoder: (p0) => p0 as List?,
        )?.cast<Object>() ??
        [];
  }

  // Chains the incoming expression context with the existing one
  ExprContext _chainExprContext(ExprContext? incoming) {
    return _createChain(exprContext, incoming);
  }

  // Creates the expression context chain
  ExprContext _createChain(ExprContext enclosing, ExprContext? exprContext) {
    if (exprContext == null) return enclosing;

    return exprContext..appendEnclosing(enclosing);
  }

  // Copies the payload with a new expression context, chaining it with the current one
  RenderPayload copyWithChainedContext(
    ExprContext exprContext, {
    BuildContext? buildContext,
  }) {
    return copyWith(
      buildContext: buildContext ?? this.buildContext,
      exprContext: _chainExprContext(exprContext),
    );
  }

  // Copies the payload with optional new buildContext and exprContext
  RenderPayload copyWith({
    BuildContext? buildContext,
    ExprContext? exprContext,
  }) {
    return RenderPayload(
      buildContext: buildContext ?? this.buildContext,
      exprContext: exprContext ?? this.exprContext,
    );
  }
}
