import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../network/api_request/api_request.dart';
import 'actions/base/action_flow.dart';
import 'expr/expression_util.dart';
import 'expr/scope_context.dart';
import 'font_factory.dart';
import 'models/types.dart';
import 'resource_provider.dart';
import 'ui_factory.dart';
import 'utils/textstyle_util.dart';
import 'utils/types.dart';

class RenderPayload {
  final BuildContext buildContext;
  final ScopeContext scopeContext;
  final ObservabilityContext? observabilityContext;

  RenderPayload({
    required this.buildContext,
    required this.scopeContext,
    this.observabilityContext,
  });

  // Retrieves an icon from a map, currently not implemented
  IconData? getIcon(Map<String, Object?>? map) {
    if (map == null) return null;

    // TODO: Yet to be implemented
    return null;
  }

  // Retrieves a color from the ResourceProvider using a key
  Color? getColor(String key) {
    return ResourceProvider.maybeOf(buildContext)?.getColor(key, buildContext);
  }

  // Retrieves an API model from the ResourceProvider using an ID
  APIModel? getApiModel(String id) {
    return ResourceProvider.maybeOf(buildContext)?.apiModels[id];
  }

  DUIFontFactory? getFontFactory() {
    return ResourceProvider.maybeOf(buildContext)?.getFontFactory();
  }

  TextStyle? getTextStyle(JsonLike? json,
      [TextStyle? fallback = defaultTextStyle]) {
    return makeTextStyle(
      json,
      context: buildContext,
      eval: eval,
      fallback: fallback,
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
      eventId: '',
      parentId: '',
    );
  }

  /// Creates a child ObservabilityContext with additional hierarchy elements
  @Deprecated('Use extendHierarchy or forTrigger methods instead')
  ObservabilityContext? withAdditionalHierarchy({
    String? triggerWidgetId,
    String? triggerType,
    List<String>? additionalHierarchy,
  }) {
    if (observabilityContext == null) return null;

    // If triggerWidgetId is provided and additionalHierarchy is null,
    // add a default hierarchy element
    final hierarchyToAdd = additionalHierarchy ??
        (triggerWidgetId != null ? [triggerWidgetId] : null);

    return observabilityContext!.copyWith(
      widgetHierarchy: hierarchyToAdd != null
          ? [...observabilityContext!.widgetHierarchy, ...hierarchyToAdd]
          : observabilityContext!.widgetHierarchy,
      triggerWidgetId: triggerWidgetId,
      triggerType: triggerType ?? observabilityContext!.triggerType,
    );
  }

  /// Extends the observability context hierarchy with additional widget names
  ///
  /// This is the preferred method for adding widgets to the hierarchy chain
  ObservabilityContext? extendHierarchy(List<String> additionalHierarchy) {
    return observabilityContext?.extendHierarchy(additionalHierarchy);
  }

  /// Creates a context for triggering an action with optional hierarchy extension
  ///
  /// This is the preferred method when executing actions that need trigger information
  ObservabilityContext? forTrigger({
    String? triggerWidgetId,
    required String triggerType,
    List<String>? additionalHierarchy,
  }) {
    return observabilityContext?.forTrigger(
      triggerWidgetId: triggerWidgetId,
      triggerType: triggerType,
      additionalHierarchy: additionalHierarchy,
    );
  }

  /// Creates a new RenderPayload with an extended hierarchy
  ///
  /// Convenience method to create a new payload with extended observability context
  RenderPayload withExtendedHierarchy(List<String> additionalHierarchy) {
    return copyWith(
      observabilityContext: extendHierarchy(additionalHierarchy),
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
    ObservabilityContext? observabilityContext,
  }) {
    return copyWith(
      buildContext: buildContext ?? this.buildContext,
      scopeContext: _chainExprContext(scopeContext),
      observabilityContext: observabilityContext ?? this.observabilityContext,
    );
  }

  // Copies the payload with optional new buildContext and scopeContext
  RenderPayload copyWith({
    BuildContext? buildContext,
    ScopeContext? scopeContext,
    ObservabilityContext? observabilityContext,
  }) {
    return RenderPayload(
      buildContext: buildContext ?? this.buildContext,
      scopeContext: scopeContext ?? this.scopeContext,
      observabilityContext: observabilityContext ?? this.observabilityContext,
    );
  }
}
