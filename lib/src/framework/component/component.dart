import 'package:flutter/widgets.dart';

import '../../network/api_request/api_request.dart';
import '../base/message_handler.dart';
import '../data_type/data_type_creator.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../models/component_definition.dart';
import '../render_payload.dart';
import '../resource_provider.dart';
import '../state/state_context.dart';
import '../state/state_scope_context.dart';
import '../state/stateful_scope_widget.dart';
import '../ui_factory.dart';
import '../utils/types.dart';
import '../virtual_widget_registry.dart';

class DUIComponent extends StatelessWidget {
  final String id;
  final JsonLike? args;
  final DUIComponentDefinition definition;
  final VirtualWidgetRegistry registry;
  final UIResources? resources;
  final ScopeContext? scope;
  final Map<String, APIModel>? apiModels;
  final DUIMessageHandler? messageHandler;
  final GlobalKey<NavigatorState>? navigatorKey;

  const DUIComponent({
    super.key,
    required this.id,
    required this.args,
    required this.definition,
    required this.registry,
    this.resources,
    this.scope,
    this.apiModels,
    this.messageHandler,
    this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedArgs = definition.argDefs
        ?.map((k, v) => MapEntry(k, args?[k] ?? v.defaultValue));
    final resolvedState = definition.initStateDefs?.map((k, v) => MapEntry(
        k,
        DataTypeCreator.create(v,
            scopeContext: DefaultScopeContext(
              variables: {...?resolvedArgs},
              enclosing: scope,
            ))));
    return ResourceProvider(
        icons: resources?.icons ?? {},
        images: resources?.images ?? {},
        textStyles: resources?.textStyles ?? {},
        colors: resources?.colors ?? {},
        apiModels: apiModels ?? {},
        messageHandler: messageHandler,
        navigatorKey: navigatorKey,
        child: StatefulScopeWidget(
          namespace: id,
          initialState: resolvedState ?? {},
          childBuilder: (context, state) {
            return _buildContent(
              context,
              _createExprContext(
                resolvedArgs,
                state,
              ),
            );
          },
        ));
  }

  Widget _buildContent(BuildContext context, ScopeContext scopeContext) {
    final rootNode = definition.layout?.root;
    // Blank Layout
    if (rootNode == null) {
      return Container();
    }

    final virtualWidget = registry.createWidget(rootNode, null);

    return virtualWidget.toWidget(
      RenderPayload(
        buildContext: context,
        scopeContext: scopeContext,
      ),
    );
  }

  ScopeContext _createExprContext(
    Map<String, Object?>? params,
    StateContext? stateContext,
  ) {
    if (stateContext == null) {
      return DefaultScopeContext(
        variables: {...?params},
        enclosing: scope,
      );
    }

    return StateScopeContext(
      stateContext: stateContext,
      variables: {...?params},
      enclosing: scope,
    );
  }
}
