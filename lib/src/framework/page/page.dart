import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/action/action_prop.dart';
import '../../models/variable_def.dart';
import '../core/virtual_state_container_widget.dart';
import '../models/vw_node_data.dart';
import '../render_payload.dart';
import '../ui_factory.dart';
import '../utils/expression_util.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/type_aliases.dart';
import '../virtual_widget_registry.dart';

class UIResourceScope extends InheritedWidget {
  final Map<String, IconData> icons;
  final Map<String, ImageProvider> images;
  final Map<String, TextStyle> textStyles;

  // final DUIMessageHandler onMessageReceived;
  final GlobalKey<NavigatorState>? navigatorKey;

  const UIResourceScope({
    super.key,
    required this.icons,
    required this.images,
    required this.textStyles,
    // required this.onMessageReceived,
    this.navigatorKey,
    required super.child,
  });

  static UIResourceScope of(BuildContext context) {
    final UIResourceScope? result =
        context.dependOnInheritedWidgetOfExactType<UIResourceScope>();
    assert(result != null, 'No UIResourceScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(UIResourceScope oldWidget) => false;
}

class DUIPageDefinition {
  final String pageUid;
  final Map<String, VariableDef>? pageArgDefs;
  final Map<String, VariableDef>? initStateDefs;
  final ({VWNodeData? root})? layout;
  final Map<String, ActionFlow>? actions;

  DUIPageDefinition({
    required this.pageUid,
    required this.pageArgDefs,
    required this.initStateDefs,
    required this.layout,
    required this.actions,
  });

  ActionFlow? get onPageLoad => actions?['onPageLoadAction'];
  ActionFlow? get executeDataSource => actions?['onPageLoad'];
  ActionFlow? get onBackPress => actions?['onBackPress'];

  factory DUIPageDefinition.fromJson(JsonLike json) {
    return DUIPageDefinition(
      pageUid: tryKeys<String>(json, ['uid', 'pageUid']) ?? '',
      actions: as$<JsonLike>(json['actions'])?.map(
        (k, v) => MapEntry(k, ActionFlow.fromJson(v)),
      ),
      pageArgDefs: tryKeys<Map<String, VariableDef>>(
        json,
        ['inputArgs', 'pageArgDefs'],
        parse: (p0) => const VariablesJsonConverter().fromJson(p0),
      ),
      initStateDefs: tryKeys<Map<String, VariableDef>>(
        json,
        ['variables', 'initStateDefs'],
        parse: (p0) => const VariablesJsonConverter().fromJson(p0),
      ),
      layout: as$<JsonLike>(json['layout']).maybe(
        (p0) => (root: VWNodeData.fromJson(p0)),
      ),
    );
  }
}

class DUIPage extends StatelessWidget {
  final String pageUid;
  final UIResources resources;
  final DUIPageDefinition pageDef;
  final VirtualWidgetRegistry registry;
  final ExprContext? scope;
  final JsonLike? pageArgs;

  const DUIPage({
    super.key,
    required this.pageUid,
    required this.pageDef,
    required this.resources,
    required this.registry,
    this.pageArgs,
    this.scope,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedArgs = pageDef.pageArgDefs?.map((k, v) => MapEntry(
          k,
          pageArgs?[k] ?? v.defaultValue,
        ));
    final resolvedState = pageDef.initStateDefs?.map((k, v) => MapEntry(
          k,
          evaluateNestedExpressions(v.defaultValue, null),
        ));
    return UIResourceScope(
        icons: resources.icons,
        images: resources.images,
        textStyles: resources.textStyles,
        child: _DUIBox(
          pageUid: pageUid,
          args: resolvedArgs,
          initialState: resolvedState,
          layout: pageDef.layout,
          registry: registry,
          scope: scope,
        ));
  }
}

class _DUIBox extends StatefulWidget {
  final String pageUid;
  final Map<String, Object?>? args;
  final Map<String, Object?>? initialState;
  final ({VWNodeData? root})? layout;
  final VirtualWidgetRegistry registry;
  final ExprContext? scope;

  const _DUIBox({
    required this.pageUid,
    required this.args,
    required this.initialState,
    required this.layout,
    required this.registry,
    this.scope,
  });

  @override
  State<_DUIBox> createState() => _DUIBoxState();
}

class _DUIBoxState extends State<_DUIBox> {
  late StateContext _stateContext;

  @override
  void initState() {
    super.initState();
    _initializeState();
    // _loadPageIfApplicable();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _onPageLoaded();
    });
  }

  void _initializeState() {
    _stateContext = StateContext(
      'page',
      stateVariables: {...?widget.initialState},
    );
  }

  // TODO: Implement this
  Future<void> _loadPageIfApplicable() async {
    // // Simulating props loading. Replace with actual loading logic.
    // await Future.delayed(const Duration(seconds: 1));
    // final props = {}; // Load actual props here
    // _stateContext.set('props', props);
    // _stateContext.set('isLoading', false);
  }

  // TODO: Implement this
  void _onPageLoaded() {
    // Handle page loaded event
  }

  @override
  Widget build(BuildContext context) {
    return StateContainer(
      nameSpace: 'page',
      initialState: _stateContext.stateVariables,
      childBuilder: (context, state) {
        return PopScope(
          onPopInvoked: _handleBackPress,
          child: _buildContent(state),
        );
      },
    );
  }

  Widget _buildContent(StateContext state) {
    final rootNode = widget.layout?.root;
    // Blank Layout
    if (rootNode == null) {
      return Container();
    }

    final virtualWidget = widget.registry.createWidget(rootNode, null);

    return virtualWidget.toWidget(RenderPayload(
      buildContext: context,
      exprContext: ExprContext(
        variables: {
          // Backwards compat
          ...state.stateVariables,
          'pageParams': widget.args,
          // New naming convention
          'state': state.stateVariables,
          'params': widget.args,
        },
        enclosing: widget.scope,
      ),
    ));
  }

  // TODO: Implement this
  void _handleBackPress(bool didPop) {
    // Handle back press event
  }
}
