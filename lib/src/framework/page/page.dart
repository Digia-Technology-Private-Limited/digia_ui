import 'package:digia_expr/digia_expr.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/action/api_handler.dart';
import '../../models/variable_def.dart';
import '../../network/api_request/api_request.dart';
import '../actions/base/action_flow.dart';
import '../base/state_context.dart';
import '../base/stateful_scope_widget.dart';
import '../internal_widgets/async_builder/controller.dart';
import '../internal_widgets/async_builder/widget.dart';
import '../models/page_definition.dart';
import '../models/vw_node_data.dart';
import '../render_payload.dart';
import '../ui_factory.dart';
import '../utils/expression_util.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';
import '../virtual_widget_registry.dart';
import 'message_handler.dart';
import 'resource_provider.dart';

class DUIPage extends StatelessWidget {
  final String pageId;
  final JsonLike? pageArgs;
  final UIResources? resources;
  final DUIPageDefinition pageDef;
  final VirtualWidgetRegistry registry;
  final ExprContext? scope;
  final Map<String, APIModel>? apiModels;
  final DUIMessageHandler? messageHandler;
  final GlobalKey<NavigatorState>? navigatorKey;

  const DUIPage({
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
  });

  @override
  Widget build(BuildContext context) {
    final resolvedArgs = pageDef.pageArgDefs
        ?.map((k, v) => MapEntry(k, pageArgs?[k] ?? v.defaultValue));
    return ResourceProvider(
        icons: resources?.icons ?? {},
        images: resources?.images ?? {},
        textStyles: resources?.textStyles ?? {},
        colors: resources?.colors ?? {},
        apiModels: apiModels ?? {},
        messageHandler: messageHandler,
        navigatorKey: navigatorKey,
        child: _DUIPageContent(
          pageId: pageId,
          args: resolvedArgs,
          initialStateDef: pageDef.initStateDefs,
          layout: pageDef.layout,
          registry: registry,
          scope: scope,
          onPageLoaded: pageDef.onPageLoad,
          onBackPress: pageDef.onBackPress,
          pageDataSource: pageDef.pageDataSource,
        ));
  }
}

class _DUIPageContent extends StatefulWidget {
  final String pageId;
  final Map<String, Object?>? args;
  final Map<String, VariableDef?>? initialStateDef;
  final ({VWNodeData? root})? layout;
  final VirtualWidgetRegistry registry;
  final ExprContext? scope;
  final ActionFlow? onPageLoaded;
  final ActionFlow? onBackPress;
  final JsonLike? pageDataSource;

  const _DUIPageContent({
    required this.pageId,
    required this.args,
    required this.initialStateDef,
    required this.layout,
    required this.registry,
    this.scope,
    this.onPageLoaded,
    this.onBackPress,
    this.pageDataSource,
  });

  @override
  State<_DUIPageContent> createState() => _DUIPageContentState();
}

class _DUIPageContentState extends State<_DUIPageContent> {
  late StateContext _stateContext;

  @override
  void initState() {
    super.initState();
    final resolvedState = widget.initialStateDef?.map((k, v) => MapEntry(
        k,
        evaluateNestedExpressions(
            v?.defaultValue, _createExprContextForPageParams())));
    _stateContext = StateContext(
      'page',
      initialState: {...?resolvedState},
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _onPageLoaded();
    });
  }

  ExprContext _createExprContextForPageParams() {
    return ExprContext(
      variables: {
        // Backward Compat
        'pageParams': widget.args,
        'params': widget.args,
      },
      enclosing: widget.scope,
    );
  }

  void _onPageLoaded() {
    if (widget.onPageLoaded != null) {
      DefaultActionExecutor.of(context).execute(
        context,
        widget.onPageLoaded!,
        _createExprContextForPageParams().copyWithNewVariables(newVariables: {
          // Backwards compat
          ..._stateContext.stateVariables,
          // New naming convention
          'state': _stateContext.stateVariables,
          // TODO: What to do api response data.
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: _handleBackPress,
        child: AsyncBuilder(
            controller: _makeController(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: SafeArea(
                        child: Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(color: Colors.blue),
                  ),
                )));
              }

              if (snapshot.hasData) {
                Future.delayed(Duration.zero, () {
                  _executeDataSourceActions(snapshot.data!);
                });
              }

              return StatefulScopeWidget(
                namespace: 'page',
                initialState: _stateContext.stateVariables,
                childBuilder: (context, state) =>
                    _buildContent(context, state, snapshot.data?.data),
              );
            }));
  }

  Widget _buildContent(
      BuildContext context, StateContext state, Object? response) {
    final rootNode = widget.layout?.root;
    // Blank Layout
    if (rootNode == null) {
      return Container();
    }

    final virtualWidget = widget.registry.createWidget(rootNode, null);

    return virtualWidget.toWidget(RenderPayload(
      buildContext: context,
      exprContext:
          _createExprContextForPageParams().copyWithNewVariables(newVariables: {
        // Backwards compat
        ...state.stateVariables,
        // New naming convention
        'state': state.stateVariables,
        'dataSource': response
      }),
    ));
  }

  void _handleBackPress(bool didPop) {
    if (widget.onBackPress != null) {
      DefaultActionExecutor.of(context).execute(
        context,
        widget.onBackPress!,
        _createExprContextForPageParams().copyWithNewVariables(newVariables: {
          // Backwards compat
          ..._stateContext.stateVariables,
          // New naming convention
          'state': _stateContext.stateVariables,
          // TODO: What to do api response data.
        }),
      );
    }
  }

  bool _shouldExecuteDataSource() =>
      widget.pageDataSource?['type'] == 'Action.loadPage';

  void _executeDataSourceActions(Response<Object?> response) async {
    final action = as$<JsonLike>(widget.pageDataSource!['data']);
    if (action == null) {
      return Future.error('Unreachable state. data is corrupt');
    }

    final respObj = {
      'body': response.data,
      'statusCode': response.statusCode,
      'headers': response.headers,
      'requestObj': _requestObjToMap(response.requestOptions),
      'error': null,
    };
    final successCondition = as$<String>(action['successCondition']);

    final isSuccess = successCondition.maybe((p0) => evaluate<bool>(p0,
            exprContext: ExprContext(
              variables: {'response': respObj},
            ))) ??
        successCondition == null || successCondition.isEmpty;

    if (isSuccess) {
      final successAction = ActionFlow.fromJson(action['onSuccess']);
      await _executeAction(
        context,
        successAction,
        ExprContext(variables: {'response': respObj}),
      );
    } else {
      final errorAction = ActionFlow.fromJson(action['onError']);
      await _executeAction(
        context,
        errorAction,
        ExprContext(variables: {'response': respObj}),
      );
    }
  }

  AsyncController<Response<Object?>> _makeController() {
    if (!_shouldExecuteDataSource()) {
      return AsyncController();
    }

    return AsyncController(futureBuilder: () {
      final action = as$<JsonLike>(widget.pageDataSource!['data']);
      if (action == null) return Future.error('Unconfigured data');

      final apiDataSourceId = as$<String>(action['dataSourceId']);
      JsonLike? apiDataSourceArgs = as$<JsonLike>(action['args']);

      final apiModel =
          ResourceProvider.maybeOf(context)?.apiModels[apiDataSourceId];

      if (apiModel == null) return Future.error('API model not found');

      final args = apiDataSourceArgs?.map((key, value) => MapEntry(key,
          evaluateNestedExpressions(value, _createExprContextForPageParams())));

      return ApiHandler.instance.execute(apiModel: apiModel, args: args);
    });
  }

  Future<Object?>? _executeAction(
    BuildContext context,
    ActionFlow actionFlow,
    ExprContext? exprContext,
  ) {
    return DefaultActionExecutor.of(context).execute(
      context,
      actionFlow,
      _createExprContextForPageParams().copyWithNewVariables(newVariables: {
        // Backwards compat
        ..._stateContext.stateVariables,
        // New naming convention
        'state': _stateContext.stateVariables,
        // TODO: What to do api response data.
      }),
    );
  }

  _requestObjToMap(RequestOptions request) {
    return {
      'url': request.path,
      'method': request.method,
      'headers': request.headers,
      'data': request.data,
      'queryParameters': request.queryParameters,
    };
  }
}
