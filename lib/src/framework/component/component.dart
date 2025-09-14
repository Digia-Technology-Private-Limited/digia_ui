import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../../init/digia_ui_manager.dart';
import '../../network/api_request/api_request.dart';
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
  final GlobalKey<NavigatorState>? navigatorKey;
  final ObservabilityContext? parentObservabilityContext;

  /// Gets the state observer from the DigiaUIManager
  static StateObserver? get stateObserver =>
      DigiaUIManager().inspector?.stateObserver;

  const DUIComponent({
    super.key,
    required this.id,
    required this.args,
    required this.definition,
    required this.registry,
    this.resources,
    this.scope,
    this.apiModels,
    this.navigatorKey,
    this.parentObservabilityContext,
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

    // Log component state creation
    final componentStateId = TimestampHelper.generateId();
    stateObserver?.onCreate(
      id: componentStateId,
      stateType: StateType.component,
      namespace: id,
      argData: resolvedArgs ?? {},
      stateData: resolvedState ?? {},
    );

    final inheritedResources = ResourceProvider.maybeOf(context);
    return ResourceProvider(
        icons: resources?.icons ?? {},
        images: resources?.images ?? {},
        textStyles: resources?.textStyles ?? {},
        fontFactory: resources?.fontFactory,
        colors: resources?.colors ?? {},
        darkColors: resources?.darkColors ?? {},
        apiModels: apiModels ?? {},
        // Only these two need to be passed. Rest all values are
        // configured at initialization time.
        navigatorKey: navigatorKey ?? inheritedResources?.navigatorKey,
        child: StatefulScopeWidget(
          namespace: id,
          initialState: resolvedState ?? {},
          stateType: StateType.component,
          childBuilder: (context, state) {
            return _buildContent(
              context,
              _createExprContext(
                resolvedArgs,
                state,
              ),
              parentObservabilityContext,
            );
          },
        ));
  }

  Widget _buildContent(
    BuildContext context,
    ScopeContext scopeContext,
    ObservabilityContext? parentObservabilityContext,
  ) {
    final rootNode = definition.layout?.root;
    // Blank Layout
    if (rootNode == null) {
      return Container();
    }

    final virtualWidget = registry.createWidget(rootNode, null);

    // Extend parent observability context for this component
    final componentObservabilityContext =
        parentObservabilityContext?.forComponent(
      componentId: id,
    );

    return virtualWidget.toWidget(
      RenderPayload(
        buildContext: context,
        scopeContext: scopeContext,
        observabilityContext: componentObservabilityContext,
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
