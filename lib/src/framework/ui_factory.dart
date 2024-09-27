import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../digia_ui_client.dart';
import 'actions/action_executor.dart';
import 'base/virtual_widget.dart';
import 'models/vw_node_data.dart';
import 'page/config_provider.dart';
import 'page/page.dart';
import 'page/page_route.dart';
import 'utils/color_util.dart';
import 'utils/functional_util.dart';
import 'utils/textstyle_util.dart';
import 'utils/types.dart';
import 'virtual_widget_registry.dart';

// This is just to inject the action executor into the widget tree
// TODO: Is there a better way to inject the action executor into the widget tree?
class DefaultActionExecutor extends InheritedWidget {
  final ActionExecutor actionExecutor;

  const DefaultActionExecutor({
    super.key,
    required this.actionExecutor,
    required super.child,
  });

  static ActionExecutor of(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<DefaultActionExecutor>()!
        .actionExecutor;
  }

  @override
  bool updateShouldNotify(DefaultActionExecutor oldWidget) => false;
}

class DUIFactory {
  static final DUIFactory _instance = DUIFactory._internal();

  factory DUIFactory() {
    return _instance;
  }

  late ConfigProvider configProvider;
  late UIResources resources;

  DUIFactory._internal();

  // Initialize the singleton with all necessary values
  void initialize({
    ConfigProvider? pageConfigProvider,
    Map<String, IconData>? icons,
    Map<String, ImageProvider>? images,
  }) {
    configProvider =
        pageConfigProvider ?? DUIConfigProvider(DigiaUIClient.instance.config);
    resources = UIResources(
      icons: icons,
      images: images,
      textStyles: DigiaUIClient.instance.config.fontTokens
          .map((key, value) => MapEntry(key, convertToTextStyle(value))),
      colors: DigiaUIClient.instance.config.colorTokens.map(
        (key, value) => MapEntry(
          key,
          as$<String>(value).maybe(ColorUtil.fromString),
        ),
      ),
    );
  }

  // Register a new widget
  void registerWidget(
      String identifier,
      VirtualWidget Function(
        VWNodeData data,
        VirtualWidgetRegistry registry,
      ) virtualWidgetBuilder) {
    VirtualWidgetRegistry.instance
        .registerWidget(identifier, virtualWidgetBuilder);
  }

  // Create a page with optional overriding UI resources
  Widget createPage(
    String pageId,
    JsonLike? pageArgs, {
    Map<String, IconData>? overrideIcons,
    Map<String, ImageProvider>? overrideImages,
    Map<String, TextStyle>? overrideTextStyles,
    Map<String, Color?>? overrideColorTokens,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    // Merge overriding resources with existing resources
    final mergedResources = UIResources(
      icons: {...?resources.icons, ...?overrideIcons},
      images: {...?resources.images, ...?overrideImages},
      textStyles: {...?resources.textStyles, ...?overrideTextStyles},
      colors: {...?resources.colors, ...?overrideColorTokens},
    );

    return DefaultActionExecutor(
      actionExecutor: ActionExecutor(
        viewBuilder: (context, viewId, args) => createPage(viewId, args),
        pageRouteBuilder: (context, id, args) => createPageRoute(id, args),
        logger: DigiaUIClient.instance.developerConfig?.logger,
      ),
      child: DUIPage(
        pageId: pageId,
        pageArgs: pageArgs,
        resources: mergedResources,
        navigatorKey: navigatorKey,
        pageDef: configProvider.getPageDefinition(pageId),
        registry: VirtualWidgetRegistry.instance,
        apiModels: configProvider.getAllApiModels(),
        scope: ExprContext(
          name: 'global',
          variables: {...DigiaUIClient.instance.jsVars},
        ),
      ),
    );
  }

  Route<Object> createPageRoute(
    String pageId,
    JsonLike? pageArgs, {
    Map<String, IconData>? overrideIcons,
    Map<String, ImageProvider>? overrideImages,
    Map<String, TextStyle>? overrideTextStyles,
    Map<String, Color?>? overrideColorTokens,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return DUIPageRoute<Object>(
        pageId: pageId,
        builder: (context) => createPage(
              pageId,
              pageArgs,
              overrideIcons: overrideIcons,
              overrideImages: overrideImages,
              overrideTextStyles: overrideTextStyles,
              overrideColorTokens: overrideColorTokens,
            ));
  }

  Widget createInitialPage({
    Map<String, IconData>? overrideIcons,
    Map<String, ImageProvider>? overrideImages,
    Map<String, TextStyle>? overrideTextStyles,
    Map<String, Color?>? overrideColorTokens,
  }) {
    return createPage(
      configProvider.getInitialRoute(),
      null,
      overrideIcons: overrideIcons,
      overrideImages: overrideImages,
      overrideTextStyles: overrideTextStyles,
      overrideColorTokens: overrideColorTokens,
    );
  }

  Widget createComponent(String componentUid) {
    return const SizedBox.shrink();
    // return DUIComponent(componentUid: componentUid);
  }
}

class UIResources {
  final Map<String, IconData>? icons;
  final Map<String, ImageProvider>? images;
  final Map<String, TextStyle?>? textStyles;
  final Map<String, Color?>? colors;

  UIResources({
    required this.icons,
    required this.images,
    required this.textStyles,
    required this.colors,
  });
}
