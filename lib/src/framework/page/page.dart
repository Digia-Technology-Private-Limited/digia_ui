import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../init/digia_ui_manager.dart';
import '../../network/api_request/api_request.dart';
import '../actions/base/action_flow.dart';
import '../data_type/data_type_creator.dart';
import '../data_type/variable.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../models/page_definition.dart';
import '../models/vw_data.dart';
import '../observability/observability_scope.dart';
import '../render_payload.dart';
import '../resource_provider.dart';
import '../state/state_context.dart';
import '../state/state_scope_context.dart';
import '../state/stateful_scope_widget.dart';
import '../ui_factory.dart';
import '../utils/types.dart';
import '../virtual_widget_registry.dart';
import 'page_controller.dart';

class DUIPage extends StatelessWidget {
  final String pageId;
  final JsonLike? pageArgs;
  final UIResources? resources;
  final DUIPageDefinition pageDef;
  final VirtualWidgetRegistry registry;
  final ScopeContext? scope;
  final Map<String, APIModel>? apiModels;
  final GlobalKey<NavigatorState>? navigatorKey;
  final DUIPageController? controller;

  /// Gets the state observer from the DigiaUIManager
  static StateObserver? get stateObserver =>
      DigiaUIManager().inspector?.stateObserver;

  const DUIPage({
    super.key,
    required this.pageId,
    required this.pageArgs,
    required this.pageDef,
    required this.registry,
    this.resources,
    this.scope,
    this.apiModels,
    this.navigatorKey,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final resolvePageArgs = pageDef.pageArgDefs
        ?.map((k, v) => MapEntry(k, pageArgs?[k] ?? v.defaultValue));
    final resolvedState = pageDef.initStateDefs?.map((k, v) => MapEntry(
        k,
        DataTypeCreator.create(v,
            scopeContext: _createExprContext(
              resolvePageArgs,
              null,
            ))));

    final stateId = IdHelper.randomId();
    stateObserver?.onCreate(
      id: stateId,
      stateType: StateType.page,
      namespace: pageId,
      argData: resolvePageArgs ?? {},
      stateData: resolvedState ?? {},
    );

    Widget child = StatefulScopeWidget(
      stateId: stateId,
      namespace: pageId,
      initialState: resolvedState ?? {},
      stateType: StateType.page,
      childBuilder: (context, state) {
        return _DUIPageContent(
          pageId: pageId,
          args: resolvePageArgs,
          initialStateDef: pageDef.initStateDefs,
          layout: pageDef.layout,
          registry: registry,
          scope: _createExprContext(
            resolvePageArgs,
            state,
          ),
          controller: controller,
          onPageLoaded: pageDef.onPageLoad,
          onBackPress: pageDef.onBackPress,
        );
      },
    );

    return ResourceProvider(
      icons: resources?.icons ?? {},
      images: resources?.images ?? {},
      textStyles: resources?.textStyles ?? {},
      fontFactory: resources?.fontFactory,
      colors: resources?.colors ?? {},
      darkColors: resources?.darkColors ?? {},
      apiModels: apiModels ?? {},
      navigatorKey: navigatorKey,
      child: child,
    );
  }

  ScopeContext _createExprContext(
    Map<String, Object?>? pageParams,
    StateContext? stateContext,
  ) {
    final pageVariables = {
      // Backward Compat
      'pageParams': pageParams,
      // New Convention,
      ...?pageParams,
    };
    if (stateContext == null) {
      return DefaultScopeContext(
        variables: pageVariables,
        enclosing: scope,
      );
    }

    return StateScopeContext(
      stateContext: stateContext,
      variables: pageVariables,
      enclosing: scope,
    );
  }
}

class _DUIPageContent extends StatefulWidget {
  final String pageId;
  final Map<String, Object?>? args;
  final Map<String, Variable?>? initialStateDef;
  final ({VWData? root})? layout;
  final VirtualWidgetRegistry registry;
  final ScopeContext scope;
  final ActionFlow? onPageLoaded;
  final ActionFlow? onBackPress;
  final DUIPageController? controller;

  const _DUIPageContent({
    required this.pageId,
    required this.args,
    required this.initialStateDef,
    required this.layout,
    required this.registry,
    required this.scope,
    this.controller,
    this.onPageLoaded,
    this.onBackPress,
  });

  @override
  State<_DUIPageContent> createState() => _DUIPageContentState();
}

class _DUIPageContentState extends State<_DUIPageContent> {
  late final ObservabilityContext observabilityContext;

  @override
  void initState() {
    super.initState();
    observabilityContext = ObservabilityContext(
      widgetHierarchy: [],
      currentEntityId: widget.pageId,
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _onPageLoaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.controller != null) {
      child = ListenableBuilder(
          listenable: widget.controller!,
          builder: (context, _) => _buildContent(context));
    } else {
      child = _buildContent(context);
    }
    return PopScope(
      onPopInvokedWithResult: _handleBackPress,
      child: child,
    );
  }

  Widget _buildContent(BuildContext context) {
    final rootNode = widget.layout?.root;
    // Blank Layout
    if (rootNode == null) {
      return Container();
    }

    final virtualWidget = widget.registry.createWidget(rootNode, null);

    return ObservabilityScope(
      value: observabilityContext,
      child: Builder(
        builder: (innerContext) => virtualWidget.toWidget(
          RenderPayload(
            buildContext: innerContext,
            scopeContext: widget.scope,
          ),
        ),
      ),
    );
  }

  void _onPageLoaded() {
    if (widget.onPageLoaded != null) {
      _executeAction(
        context,
        widget.onPageLoaded!,
        widget.scope,
        observabilityContext.forTrigger(triggerType: 'onPageLoad'),
      );
    }
  }

  void _handleBackPress(bool didPop, Object? result) {
    if (widget.onBackPress != null) {
      _executeAction(
        context,
        widget.onBackPress!,
        widget.scope,
        observabilityContext.forTrigger(triggerType: 'onBackPress'),
      );
    }
  }

  Future<Object?>? _executeAction(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext,
    ObservabilityContext observabilityContext,
  ) {
    return DefaultActionExecutor.of(context).execute(
      context,
      actionFlow,
      scopeContext,
      id: IdHelper.randomId(),
      observabilityContext: observabilityContext,
    );
  }
}
