import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/action/api_handler.dart';
import '../../models/variable_def.dart';
import '../../network/api_request/api_request.dart';
import '../actions/base/action_flow.dart';
import '../base/message_handler.dart';
import '../expr/default_scope_context.dart';
import '../expr/expression_util.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/async_builder/controller.dart';
import '../internal_widgets/async_builder/widget.dart';
import '../models/page_definition.dart';
import '../models/vw_data.dart';
import '../render_payload.dart';
import '../resource_provider.dart';
import '../state/state_context.dart';
import '../state/state_scope_context.dart';
import '../state/stateful_scope_widget.dart';
import '../ui_factory.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';
import '../virtual_widget_registry.dart';
import 'type_creator.dart';

class DUIPage extends StatelessWidget {
  final String pageId;
  final JsonLike? pageArgs;
  final UIResources? resources;
  final DUIPageDefinition pageDef;
  final VirtualWidgetRegistry registry;
  final ScopeContext? scope;
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
    final resolvePageArgs = pageDef.pageArgDefs
        ?.map((k, v) => MapEntry(k, pageArgs?[k] ?? v.defaultValue));
    TypeCreator.initialize(resolvePageArgs);
    final resolvedState = pageDef.initStateDefs
        ?.map((k, v) => MapEntry(k, TypeCreator.create(v)));

    return ResourceProvider(
        icons: resources?.icons ?? {},
        images: resources?.images ?? {},
        textStyles: resources?.textStyles ?? {},
        colors: resources?.colors ?? {},
        apiModels: apiModels ?? {},
        messageHandler: messageHandler,
        navigatorKey: navigatorKey,
        child: StatefulScopeWidget(
          namespace: 'page',
          initialState: resolvedState ?? {},
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
              onPageLoaded: pageDef.onPageLoad,
              onBackPress: pageDef.onBackPress,
              pageDataSource: pageDef.pageDataSource,
            );
          },
        ));
  }

  ScopeContext _createExprContext(
    Map<String, Object?>? pageParams,
    StateContext? stateContext,
  ) {
    final pageVariables = {
      // Backward Compat
      'pageParams': pageParams,
      // New Naming Convention,
      'params': pageParams,
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
  final Map<String, VariableDef?>? initialStateDef;
  final ({VWData? root})? layout;
  final VirtualWidgetRegistry registry;
  final ScopeContext? scope;
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
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _onPageLoaded();
    });
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

              return _buildContent(context, snapshot.data?.data);
            }));
  }

  Widget _buildContent(BuildContext context, Object? response) {
    final rootNode = widget.layout?.root;
    // Blank Layout
    if (rootNode == null) {
      return Container();
    }

    final virtualWidget = widget.registry.createWidget(rootNode, null);

    return virtualWidget.toWidget(
      RenderPayload(
        buildContext: context,
        scopeContext: _createExprContext(response),
      ),
    );
  }

  ScopeContext _createExprContext(Object? response) {
    return DefaultScopeContext(
      variables: {
        'dataSource': response,
      },
      enclosing: widget.scope,
    );
  }

  void _onPageLoaded() {
    if (widget.onPageLoaded != null) {
      DefaultActionExecutor.of(context).execute(
        context,
        widget.onPageLoaded!,
        null,
      );
    }
  }

  void _handleBackPress(bool didPop) {
    if (widget.onBackPress != null) {
      DefaultActionExecutor.of(context).execute(
        context,
        widget.onBackPress!,
        _createExprContext(null),
      );
    }
  }

  bool _shouldExecuteDataSource() =>
      widget.pageDataSource?['type'] == 'Action.loadPage';

  Future<void> _executeDataSourceActions(Response<Object?> response) async {
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
            scopeContext: DefaultScopeContext(
              variables: {'response': respObj},
            ))) ??
        successCondition == null || successCondition.isEmpty;

    if (isSuccess) {
      final successAction = ActionFlow.fromJson(action['onSuccess']);
      if (successAction != null) {
        await _executeAction(
          context,
          successAction,
          DefaultScopeContext(variables: {'response': respObj}),
        );
      }
    } else {
      final errorAction = ActionFlow.fromJson(action['onError']);
      if (errorAction != null) {
        await _executeAction(
          context,
          errorAction,
          DefaultScopeContext(variables: {'response': respObj}),
        );
      }
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

      final args = apiDataSourceArgs?.map((key, value) => MapEntry(
          key, evaluateNestedExpressions(value, _createExprContext(null))));

      final response = ApiHandler.instance
          .execute(apiModel: apiModel, args: args)
          .then((value) {
        _executeDataSourceActions(value);
        return value;
      });

      return response;
    });
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
