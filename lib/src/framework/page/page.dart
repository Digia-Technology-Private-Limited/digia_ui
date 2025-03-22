import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../digia_ui.dart';
import '../../network/api_request/api_request.dart';
import '../actions/base/action_flow.dart';
import '../base/message_handler.dart';
import '../data_type/data_type_creator.dart';
import '../data_type/variable.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../models/page_definition.dart';
import '../models/vw_data.dart';
import '../render_payload.dart';
import '../resource_provider.dart';
import '../state/state_context.dart';
import '../state/state_scope_context.dart';
import '../state/stateful_scope_widget.dart';
import '../ui_factory.dart';
import '../utils/types.dart';
import '../virtual_widget_registry.dart';
import 'page_controller.dart';

class DUIPage extends StatefulWidget {
  final String pageId;
  final JsonLike? pageArgs;
  final UIResources? resources;
  DUIPageDefinition pageDef;
  final VirtualWidgetRegistry registry;
  final ScopeContext? scope;
  final Map<String, APIModel>? apiModels;
  final DUIMessageHandler? messageHandler;
  final GlobalKey<NavigatorState>? navigatorKey;
  final DUIPageController? controller;

  DUIPage({
    super.key,
    required this.pageId,
    required this.pageArgs,
    required this.pageDef,
    required this.registry,
    this.resources,
    this.scope,
    this.apiModels,
    this.messageHandler,
    this.navigatorKey,
    this.controller,
  });

  @override
  State<DUIPage> createState() => _DUIPageState();
}

class _DUIPageState extends State<DUIPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((d) {
      DigiaUIClient.instance.reloadCentral?.configStream.listen(
        (data) {
          setState(() {
            widget.pageDef = DUIFactory().configProvider.getPageDefinition(widget.pageId);
          });
        },
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    DigiaUIClient.instance.reloadCentral?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resolvePageArgs = widget.pageDef.pageArgDefs
        ?.map((k, v) => MapEntry(k, widget.pageArgs?[k] ?? v.defaultValue));
    final resolvedState = widget.pageDef.initStateDefs?.map((k, v) => MapEntry(
        k,
        DataTypeCreator.create(v,
            scopeContext: DefaultScopeContext(
              variables: {...?resolvePageArgs},
              enclosing: widget.scope,
            ))));

    Widget child = StatefulScopeWidget(
      namespace: widget.pageId,
      initialState: resolvedState ?? {},
      childBuilder: (context, state) {
        return _DUIPageContent(
          pageId: widget.pageId,
          args: resolvePageArgs,
          initialStateDef: widget.pageDef.initStateDefs,
          layout: widget.pageDef.layout,
          registry: widget.registry,
          scope: _createExprContext(
            resolvePageArgs,
            state,
          ),
          controller: widget.controller,
          onPageLoaded: widget.pageDef.onPageLoad,
          onBackPress: widget.pageDef.onBackPress,
        );
      },
    );

    return ResourceProvider(
      icons: widget.resources?.icons ?? {},
      images: widget.resources?.images ?? {},
      textStyles: widget.resources?.textStyles ?? {},
      fontFactory: widget.resources?.fontFactory,
      colors: widget.resources?.colors ?? {},
      apiModels: widget.apiModels ?? {},
      messageHandler: widget.messageHandler,
      navigatorKey: widget.navigatorKey,
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
        enclosing: widget.scope,
      );
    }

    return StateScopeContext(
      stateContext: stateContext,
      variables: pageVariables,
      enclosing: widget.scope,
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
  @override
  void initState() {
    super.initState();
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
      onPopInvoked: _handleBackPress,
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

    return virtualWidget.toWidget(
      RenderPayload(
        buildContext: context,
        scopeContext: widget.scope,
      ),
    );
  }

  void _onPageLoaded() {
    if (widget.onPageLoaded != null) {
      _executeAction(context, widget.onPageLoaded!, widget.scope);
    }
  }

  void _handleBackPress(bool didPop) {
    if (widget.onBackPress != null) {
      _executeAction(context, widget.onBackPress!, widget.scope);
    }
  }

  Future<Object?>? _executeAction(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext,
  ) {
    return DefaultActionExecutor.of(context).execute(
      context,
      actionFlow,
      scopeContext,
    );
  }
}
