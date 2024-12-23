import 'package:flutter/widgets.dart';

import '../digia_ui_client.dart';
import 'actions/action_executor.dart';
import 'base/message_handler.dart';
import 'base/virtual_widget.dart';
import 'component/component.dart';
import 'data_type/method_bindings/method_binding_registry.dart';
import 'expr/default_scope_context.dart';
import 'font_factory.dart';
import 'page/config_provider.dart';
import 'page/page.dart';
import 'page/page_controller.dart';
import 'page/page_route.dart';
import 'utils/color_util.dart';
import 'utils/functional_util.dart';
import 'utils/navigation_util.dart';
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
  late VirtualWidgetRegistry widgetRegistry;
  late MethodBindingRegistry bindingRegistry;

  DUIFactory._internal();

  // Initialize the singleton with all necessary values
  void initialize({
    ConfigProvider? pageConfigProvider,
    Map<String, IconData>? icons,
    Map<String, ImageProvider>? images,
    DUIFontFactory? fontFactory,
  }) {
    widgetRegistry = DefaultVirtualWidgetRegistry(
      componentBuilder: (id, args) => createComponent(id, args),
    );
    bindingRegistry = MethodBindingRegistry();

    configProvider =
        pageConfigProvider ?? DUIConfigProvider(DigiaUIClient.instance.config);
    resources = UIResources(
      icons: icons,
      images: images,
      textStyles:
          DigiaUIClient.instance.config.fontTokens.map((key, value) => MapEntry(
                key,
                convertToTextStyle(value, fontFactory),
              )),
      fontFactory: fontFactory,
      colors: DigiaUIClient.instance.config.colorTokens.map(
        (key, value) => MapEntry(
          key,
          as$<String>(value).maybe(ColorUtil.fromString),
        ),
      ),
    );
  }

  // Register a new widget
  void registerWidget<T>(
    String type,
    T Function(JsonLike) fromJsonT,
    VirtualWidget Function(
      T props,
      Map<String, List<VirtualWidget>>? childGroups,
    ) builder,
  ) {
    widgetRegistry.registerWidget(type, fromJsonT, builder);
  }

  // Register a new widget
  void registerJsonWidget(
    String type,
    VirtualWidget Function(
      JsonLike props,
      Map<String, List<VirtualWidget>>? childGroups,
    ) builder,
  ) {
    widgetRegistry.registerJsonWidget(type, builder);
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
    DUIMessageHandler? messageHandler,
    DUIPageController? pageController,
  }) {
    // Merge overriding resources with existing resources
    final mergedResources = UIResources(
      icons: {...?resources.icons, ...?overrideIcons},
      images: {...?resources.images, ...?overrideImages},
      textStyles: {...?resources.textStyles, ...?overrideTextStyles},
      colors: {...?resources.colors, ...?overrideColorTokens},
      fontFactory: resources.fontFactory,
    );

    final handler =
        messageHandler?.propagateHandler == true ? messageHandler : null;
    final pageDef = configProvider.getPageDefinition(pageId);

    return DefaultActionExecutor(
      actionExecutor: ActionExecutor(
        viewBuilder: (context, id, args) =>
            _buildView(context, id, args, handler),
        pageRouteBuilder: (context, id, args) =>
            createPageRoute(id, args, messageHandler: handler),
        bindingRegistry: bindingRegistry,
        logger: DigiaUIClient.instance.developerConfig?.logger,
      ),
      child: DUIPage(
        pageId: pageId,
        pageArgs: pageArgs,
        resources: mergedResources,
        navigatorKey: navigatorKey,
        pageDef: pageDef,
        registry: widgetRegistry,
        apiModels: configProvider.getAllApiModels(),
        messageHandler: messageHandler,
        controller: pageController,
        scope: DefaultScopeContext(
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
    DUIMessageHandler? messageHandler,
    DUIPageController? pageController,
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
              navigatorKey: navigatorKey,
              messageHandler: messageHandler,
              pageController: pageController,
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

  Widget _buildView(
    BuildContext context,
    String viewId,
    JsonLike? args,
    DUIMessageHandler? messageHandler,
  ) {
    if (configProvider.isPage(viewId)) {
      return createPage(viewId, args, messageHandler: messageHandler);
    }

    return createComponent(viewId, args, messageHandler: messageHandler);
  }

  // TODO: What should be done about MessageHandler here?
  // Show it propagate to Page?
  Widget createComponent(
    String componentid,
    JsonLike? args, {
    Map<String, IconData>? overrideIcons,
    Map<String, ImageProvider>? overrideImages,
    Map<String, TextStyle>? overrideTextStyles,
    Map<String, Color?>? overrideColorTokens,
    GlobalKey<NavigatorState>? navigatorKey,
    DUIMessageHandler? messageHandler,
  }) {
    // Merge overriding resources with existing resources
    final mergedResources = UIResources(
      icons: {...?resources.icons, ...?overrideIcons},
      images: {...?resources.images, ...?overrideImages},
      textStyles: {...?resources.textStyles, ...?overrideTextStyles},
      colors: {...?resources.colors, ...?overrideColorTokens},
      fontFactory: resources.fontFactory,
    );

    final componentDef = configProvider.getComponentDefinition(componentid);

    return DefaultActionExecutor(
      actionExecutor: ActionExecutor(
        viewBuilder: (context, id, args) =>
            _buildView(context, id, args, messageHandler),
        pageRouteBuilder: (context, id, args) =>
            createPageRoute(id, args, messageHandler: messageHandler),
        bindingRegistry: bindingRegistry,
        logger: DigiaUIClient.instance.developerConfig?.logger,
      ),
      child: DUIComponent(
        id: componentid,
        args: args,
        resources: mergedResources,
        navigatorKey: navigatorKey,
        definition: componentDef,
        registry: widgetRegistry,
        apiModels: configProvider.getAllApiModels(),
        messageHandler: messageHandler,
        scope: DefaultScopeContext(
          name: 'global',
          variables: {...DigiaUIClient.instance.jsVars},
        ),
      ),
    );
  }

  Future<T?> showBottomSheet<T>(
    BuildContext context,
    String viewId,
    JsonLike? args, {
    double scrollControlDisabledMaxHeightRatio = 1,
    Color? backgroundColor,
    Color? barrierColor,
    BoxBorder? border,
    BorderRadius? borderRadius,
    WidgetBuilder? iconBuilder,
    GlobalKey<NavigatorState>? navigatorKey,
    DUIMessageHandler? messageHandler,
  }) {
    return presentBottomSheet(
      context: context,
      builder: (innerCtx) => _buildView(innerCtx, viewId, args, messageHandler),
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      border: border,
      borderRadius: borderRadius,
      iconBuilder: iconBuilder,
      navigatorKey: navigatorKey,
    );
  }
}

class UIResources {
  final Map<String, IconData>? icons;
  final Map<String, ImageProvider>? images;
  final Map<String, TextStyle?>? textStyles;
  final Map<String, Color?>? colors;
  final DUIFontFactory? fontFactory;

  UIResources({
    required this.icons,
    required this.images,
    required this.textStyles,
    required this.colors,
    this.fontFactory,
  });
}
