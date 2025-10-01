import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../init/digia_ui_manager.dart';
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
  final List<String> widgetHierarchy;
  final String? currentEntityId;

  RenderPayload({
    required this.buildContext,
    required this.scopeContext,
    this.widgetHierarchy = const [],
    this.currentEntityId,
  });

  // Retrieves an icon from a map, currently not implemented
  IconData? getIcon(Map<String, Object?>? map) {
    if (map == null) return null;

    // TODO: Yet to be implemented
    return null;
  }

  /// Gets the current ObservabilityContext from payload fields
  ObservabilityContext? get observabilityContext {
    // Only create if inspector is enabled
    if (!DigiaUIManager().isInspectorEnabled) return null;

    return ObservabilityContext(
      widgetHierarchy: widgetHierarchy,
      currentEntityId: currentEntityId,
    );
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

  /// Executes an action flow with optional trigger context
  Future<Object?>? executeAction(
    ActionFlow? actionFlow, {
    ScopeContext? scopeContext,
    String? triggerType,
  }) {
    if (actionFlow == null) return null;

    // Create observability context with trigger type if enabled
    ObservabilityContext? observabilityContextWithTrigger;
    if (DigiaUIManager().isInspectorEnabled &&
        (currentEntityId != null || widgetHierarchy.isNotEmpty)) {
      observabilityContextWithTrigger = ObservabilityContext(
        widgetHierarchy: widgetHierarchy,
        currentEntityId: currentEntityId,
        triggerType: triggerType,
      );
    }

    return DefaultActionExecutor.of(buildContext).execute(
      buildContext,
      actionFlow,
      _chainExprContext(scopeContext),
      id: IdHelper.randomId(),
      observabilityContext: observabilityContextWithTrigger,
    );
  }

  /// Creates a new RenderPayload with an extended widget hierarchy
  ///
  /// This is used when a VirtualWidget renders its children to add itself
  /// to the hierarchy chain
  RenderPayload withExtendedHierarchy(String widgetName) {
    return copyWith(
      widgetHierarchy: [...widgetHierarchy, widgetName],
    );
  }

  /// Creates a new RenderPayload for a component, replacing the entity ID
  /// and preserving the page hierarchy as a prefix
  RenderPayload forComponent({required String componentId}) {
    // When entering a component from a page, preserve the page hierarchy
    // by adding the component ID to the hierarchy
    return copyWith(
      widgetHierarchy: [...widgetHierarchy, componentId],
      currentEntityId: componentId,
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
  }) {
    return copyWith(
      buildContext: buildContext ?? this.buildContext,
      scopeContext: _chainExprContext(scopeContext),
    );
  }

  // Copies the payload with optional new fields
  RenderPayload copyWith({
    BuildContext? buildContext,
    ScopeContext? scopeContext,
    List<String>? widgetHierarchy,
    String? currentEntityId,
  }) {
    return RenderPayload(
      buildContext: buildContext ?? this.buildContext,
      scopeContext: scopeContext ?? this.scopeContext,
      widgetHierarchy: widgetHierarchy ?? this.widgetHierarchy,
      currentEntityId: currentEntityId ?? this.currentEntityId,
    );
  }
}
