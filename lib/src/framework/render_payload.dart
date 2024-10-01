import 'package:flutter/widgets.dart';

import '../network/api_request/api_request.dart';
import 'actions/base/action_flow.dart';
import 'expr/expression_util.dart';
import 'expr/scope_context.dart';
import 'models/types.dart';
import 'models/vw_repeat_data.dart';
import 'resource_provider.dart';
import 'ui_factory.dart';
import 'utils/object_util.dart';
import 'utils/textstyle_util.dart';
import 'utils/types.dart';

class RenderPayload {
  final BuildContext buildContext;
  final ScopeContext scopeContext;

  RenderPayload({required this.buildContext, required this.scopeContext});

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

  TextStyle? getTextStyle(JsonLike? json) {
    return makeTextStyle(
      json,
      context: buildContext,
      eval: eval,
    );
  }

  // Executes an action flow with an optional expression context
  Future<Object?>? executeAction(
    ActionFlow? actionFlow, {
    ScopeContext? scopeContext,
  }) {
    if (actionFlow == null) return null;

    return DefaultActionExecutor.of(buildContext).execute(
      buildContext,
      actionFlow,
      _chainExprContext(scopeContext),
    );
  }

  T? evalExpr<T extends Object>(ExprOr<T>? expr,
      {T? Function(Object)? decoder}) {
    return expr?.evaluate(scopeContext, decoder: decoder);
  }

  // Evaluates an expression with an optional chained expression context
  T? eval<T extends Object>(Object? expression,
      {ScopeContext? scopeContext, T? Function(Object?)? decoder}) {
    return evaluate<T>(
      expression,
      scopeContext: _chainExprContext(scopeContext),
      decoder: decoder,
    );
  }

  Color? evalColorExpr(ExprOr<String>? expression,
      {ScopeContext? scopeContext, String? Function(Object?)? decoder}) {
    final colorString = expression?.evaluate(scopeContext, decoder: decoder);

    if (colorString == null) return null;

    return getColor(colorString);
  }

  // Evaluates and retrieves a color from the ResourceProvider
  Color? evalColor(Object? expression,
      {ScopeContext? scopeContext, String? Function(Object?)? decoder}) {
    final colorString = eval<String>(
      expression,
      scopeContext: scopeContext,
      decoder: decoder,
    );

    if (colorString == null) return null;

    return getColor(colorString);
  }

  // Evaluates and retrieves repeatable data
  List<Object> evalRepeatData(VWRepeatData data) {
    if (data.isJson) {
      return data.datum?.to<List<Object>>() ?? [];
    }

    return eval<List<Object>>(data.datum) ?? [];
  }

  // Chains the incoming expression context with the existing one
  ScopeContext _chainExprContext(ScopeContext? incoming) {
    return _createChain(scopeContext, incoming);
  }

  // Creates the expression context chain
  ScopeContext _createChain(
    ScopeContext enclosing,
    ScopeContext? incoming,
  ) {
    if (incoming == null) return enclosing;

    return incoming..addContextAtTail(enclosing);
  }

  // Copies the payload with a new expression context, chaining it with the current one
  RenderPayload copyWithChainedContext(
    ScopeContext scopeContext, {
    BuildContext? buildContext,
  }) {
    return copyWith(
      buildContext: buildContext ?? this.buildContext,
      scopeContext: _chainExprContext(scopeContext),
    );
  }

  // Copies the payload with optional new buildContext and scopeContext
  RenderPayload copyWith({
    BuildContext? buildContext,
    ScopeContext? scopeContext,
  }) {
    return RenderPayload(
      buildContext: buildContext ?? this.buildContext,
      scopeContext: scopeContext ?? this.scopeContext,
    );
  }
}
