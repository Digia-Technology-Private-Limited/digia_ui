import 'package:digia_expr/digia_expr.dart';
import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../config/app_state/app_state_scope_context.dart';
import '../config/app_state/global_state.dart';
import '../init/digia_ui_manager.dart';
import 'actions/action_execution_context.dart';
import 'actions/action_executor.dart';
import 'base/virtual_widget.dart';
import 'component/component.dart';
import 'data_type/method_bindings/method_binding_registry.dart';
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

/// Injectable widget that provides an ActionExecutor to the widget tree.
///
/// This is an internal implementation detail that allows action execution
/// capabilities to be accessed throughout the widget tree via InheritedWidget.
/// The ActionExecutor handles navigation, state management, API calls, and
/// other pre-built actions defined in the Digia UI system.
// TODO: Is there a better way to inject the action executor into the widget tree?
class DefaultActionExecutor extends InheritedWidget {
  /// The action executor instance that handles all action execution
  final ActionExecutor actionExecutor;

  const DefaultActionExecutor({
    super.key,
    required this.actionExecutor,
    required super.child,
  });

  /// Retrieves the ActionExecutor from the widget tree
  ///
  /// This method should be called from within the widget tree to access
  /// action execution capabilities. Throws if no DefaultActionExecutor
  /// is found in the ancestor tree.
  static ActionExecutor of(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<DefaultActionExecutor>()!
        .actionExecutor;
  }

  @override
  bool updateShouldNotify(DefaultActionExecutor oldWidget) => false;
}

/// Central factory class for creating Digia UI widgets, pages, and components.
///
/// [DUIFactory] is a singleton that serves as the main entry point for creating
/// UI elements from JSON configurations. It manages UI resources, widget registries,
/// and provides methods for creating various UI elements with optional customization.
///
/// Key responsibilities:
/// - Creating pages and components from JSON definitions
/// - Managing UI resources (icons, images, fonts, colors)
/// - Handling widget registration for custom components
/// - Providing resource override capabilities
/// - Managing navigation routes and bottom sheets
///
/// Example usage:
/// ```dart
/// // Create a page
/// Widget page = DUIFactory().createPage('pageId', {'key': 'value'});
///
/// // Create a component
/// Widget component = DUIFactory().createComponent('componentId', args);
///
/// // Register custom widget
/// DUIFactory().registerWidget<MyProps>(
///   'custom/myWidget',
///   MyProps.fromJson,
///   (props, childGroups) => MyCustomWidget(props),
/// );
/// ```
class DUIFactory {
  /// Singleton instance of the factory
  static final DUIFactory _instance = DUIFactory._internal();

  /// Returns the singleton instance of DUIFactory
  factory DUIFactory() {
    return _instance;
  }

  /// Page and component configuration provider
  late ConfigProvider configProvider;

  /// UI resources including icons, images, fonts, and colors
  late UIResources resources;

  /// Registry for managing virtual widget types and their builders
  late VirtualWidgetRegistry widgetRegistry;

  /// Registry for method bindings used in expressions
  late MethodBindingRegistry bindingRegistry;

  /// Execution context for the factory
  late ActionExecutionContext executionContext;

  /// Private constructor for singleton pattern
  DUIFactory._internal();

  /// Initializes the singleton factory with all necessary configuration and resources.
  ///
  /// This method must be called before using any other factory methods. It sets up
  /// the widget registry, binding registry, configuration provider, and UI resources
  /// based on the initialized DigiaUI instance and optional custom resources.
  ///
  /// Parameters:
  /// - [pageConfigProvider]: Custom configuration provider for pages and components
  /// - [icons]: Custom icon mappings to override or extend default icons
  /// - [images]: Custom image provider mappings for app-specific images
  /// - [fontFactory]: Custom font factory for creating text styles
  ///
  /// Throws [StateError] if DigiaUIManager is not properly initialized.
  ///
  /// Note: Environment variables should be set using the dedicated methods:
  /// - [setEnvironmentVariable] for single variables
  /// - [setEnvironmentVariables] for multiple variables
  /// - [clearEnvironmentVariable] for single variables
  /// - [clearEnvironmentVariables] for multiple variables
  // Initialize the singleton with all necessary values
  void initialize({
    ConfigProvider? pageConfigProvider,
    Map<String, IconData>? icons,
    Map<String, ImageProvider>? images,
    DUIFontFactory? fontFactory,
  }) {
    // Ensure DigiaUIManager is properly initialized before proceeding
    final digiaUIInstance = DigiaUIManager().safeInstance;
    if (digiaUIInstance == null) {
      throw StateError(
          'DigiaUIManager is not initialized. Make sure to call DigiaUI.initialize() '
          'and await its completion before calling DUIFactory().initialize().');
    }

    // Initialize widget registry with component builder
    widgetRegistry = DefaultVirtualWidgetRegistry(
      // MessageHandler is not propagated here
      componentBuilder: (id, args, observabilityContext) =>
          createComponent(id, args, observabilityContext: observabilityContext),
    );

    // Initialize method binding registry for expression evaluation
    bindingRegistry = MethodBindingRegistry();

    // Initialize execution context for action execution
    executionContext = ActionExecutionContext(
      actionObserver: DigiaUIManager().inspector!.actionObserver!,
      observabilityContext:
          ObservabilityContext(widgetHierarchy: [], triggerType: ''),
    );

    // Set up configuration provider (use custom or default)
    configProvider =
        pageConfigProvider ?? DUIConfigProvider(digiaUIInstance.dslConfig);

    // Build UI resources from configuration and custom overrides
    resources = UIResources(
      icons: icons,
      images: images,
      // Convert font tokens from configuration to TextStyle objects
      textStyles:
          digiaUIInstance.dslConfig.fontTokens.map((key, value) => MapEntry(
                key,
                convertToTextStyle(value, fontFactory),
              )),
      fontFactory: fontFactory,
      // Convert color tokens from configuration
      colors: digiaUIInstance.dslConfig.colorTokens.map(
        (key, value) => MapEntry(
          key,
          as$<String>(value).maybe(ColorUtil.fromString),
        ),
      ),
      // Convert dark mode color tokens
      darkColors: digiaUIInstance.dslConfig.darkColorTokens.map(
        (key, value) => MapEntry(
          key,
          as$<String>(value).maybe(ColorUtil.fromString),
        ),
      ),
    );
  }

  /// Sets a single environment variable value at runtime.
  ///
  /// This method allows updating environment variables after configuration
  /// loading, which is useful for dynamic configuration based on user
  /// preferences or runtime conditions.
  ///
  /// Parameters:
  /// - [varName]: The name of the environment variable to update
  /// - [value]: The new value to set for the variable
  ///
  /// The method only updates variables that already exist in the configuration.
  /// If the variable doesn't exist, the method returns without making changes.
  ///
  /// Example:
  /// ```dart
  /// DUIFactory().setEnvironmentVariable('baseUrl', 'https://new-api.example.com');
  /// DUIFactory().setEnvironmentVariable('userId', 12345);
  /// DUIFactory().setEnvironmentVariable('isLoggedIn', true);
  /// ```
  void setEnvironmentVariable(String varName, Object? value) {
    final digiaUIInstance = DigiaUIManager().safeInstance;
    if (digiaUIInstance == null) {
      throw StateError(
          'DigiaUIManager is not initialized. Make sure to call DigiaUI.createWith() '
          'and await its completion before calling DUIFactory().setEnvironmentVariable().');
    }
    digiaUIInstance.dslConfig.setEnvVariable(varName, value);
  }

  /// Sets multiple environment variables at once.
  ///
  /// This method allows updating multiple environment variables simultaneously,
  /// which is more efficient than calling setEnvironmentVariable multiple times.
  ///
  /// Parameters:
  /// - [variables]: A map of variable names to their new values
  ///
  /// Only variables that already exist in the configuration will be updated.
  /// Non-existent variables will be ignored.
  ///
  /// Example:
  /// ```dart
  /// DUIFactory().setEnvironmentVariables({
  ///   'baseUrl': 'https://api.example.com',
  ///   'userId': 12345,
  ///   'isLoggedIn': true,
  ///   'theme': 'dark',
  /// });
  /// ```
  void setEnvironmentVariables(Map<String, Object?> variables) {
    final digiaUIInstance = DigiaUIManager().safeInstance;
    if (digiaUIInstance == null) {
      throw StateError(
          'DigiaUIManager is not initialized. Make sure to call DigiaUI.createWith() '
          'and await its completion before calling DUIFactory().setEnvironmentVariables().');
    }
    for (final entry in variables.entries) {
      digiaUIInstance.dslConfig.setEnvVariable(entry.key, entry.value);
    }
  }

  /// Clears a single environment variable value at runtime.
  ///
  /// This method resets an environment variable to null, effectively clearing
  /// its value while keeping the variable definition in the configuration.
  ///
  /// Parameters:
  /// - [varName]: The name of the environment variable to clear
  ///
  /// The method only clears variables that already exist in the configuration.
  /// If the variable doesn't exist, the method returns without making changes.
  ///
  /// Example:
  /// ```dart
  /// DUIFactory().clearEnvironmentVariable('baseUrl');
  /// DUIFactory().clearEnvironmentVariable('userId');
  /// ```
  void clearEnvironmentVariable(String varName) {
    final digiaUIInstance = DigiaUIManager().safeInstance;
    if (digiaUIInstance == null) {
      throw StateError(
          'DigiaUIManager is not initialized. Make sure to call DigiaUI.createWith() '
          'and await its completion before calling DUIFactory().clearEnvironmentVariable().');
    }
    digiaUIInstance.dslConfig.setEnvVariable(varName, null);
  }

  /// Clears multiple environment variables at once.
  ///
  /// This method resets multiple environment variables to null simultaneously,
  /// which is more efficient than calling clearEnvironmentVariable multiple times.
  ///
  /// Parameters:
  /// - [varNames]: A list of variable names to clear
  ///
  /// Only variables that already exist in the configuration will be cleared.
  /// Non-existent variables will be ignored.
  ///
  /// Example:
  /// ```dart
  /// DUIFactory().clearEnvironmentVariables([
  ///   'baseUrl',
  ///   'userId',
  ///   'isLoggedIn',
  ///   'theme',
  /// ]);
  /// ```
  void clearEnvironmentVariables(List<String> varNames) {
    final digiaUIInstance = DigiaUIManager().safeInstance;
    if (digiaUIInstance == null) {
      throw StateError(
          'DigiaUIManager is not initialized. Make sure to call DigiaUI.createWith() '
          'and await its completion before calling DUIFactory().clearEnvironmentVariables().');
    }
    for (final varName in varNames) {
      digiaUIInstance.dslConfig.setEnvVariable(varName, null);
    }
  }

  /// Destroys the factory and cleans up all resources.
  ///
  /// This method should be called when the factory is no longer needed,
  /// typically during app shutdown. It disposes of the widget registry
  /// and binding registry to free up resources.
  // Destroy the factory
  void destroy() {
    widgetRegistry.dispose();
    bindingRegistry.dispose();
  }

  /// Registers a new custom widget type with type-safe properties.
  ///
  /// This method allows you to extend Digia UI with custom Flutter widgets
  /// that can be used in JSON configurations. The widget will be identified
  /// by the provided [type] string and can receive typed properties.
  ///
  /// Parameters:
  /// - [type]: Unique identifier for the widget type (e.g., 'custom/myWidget')
  /// - [fromJsonT]: Function to deserialize JSON to typed properties
  /// - [builder]: Function that creates the VirtualWidget from properties
  ///
  /// Example:
  /// ```dart
  /// DUIFactory().registerWidget<MapProps>(
  ///   'custom/map',
  ///   MapProps.fromJson,
  ///   (props, childGroups) => CustomMapWidget(props),
  /// );
  /// ```
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

  /// Registers a new custom widget type that works directly with JSON properties.
  ///
  /// This is a simpler alternative to [registerWidget] when you don't need
  /// type-safe properties and prefer to work directly with JSON-like objects.
  ///
  /// Parameters:
  /// - [type]: Unique identifier for the widget type
  /// - [builder]: Function that creates the VirtualWidget from JSON properties
  ///
  /// Example:
  /// ```dart
  /// DUIFactory().registerJsonWidget(
  ///   'custom/simpleWidget',
  ///   (props, childGroups) => SimpleWidget(props['text']),
  /// );
  /// ```
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

  /// Creates a page widget from a JSON configuration with optional resource overrides.
  ///
  /// Pages are full-screen UI definitions that typically represent app screens
  /// with their own lifecycle, state management, and navigation capabilities.
  ///
  /// Parameters:
  /// - [pageId]: Unique identifier for the page configuration
  /// - [pageArgs]: Arguments to pass to the page (accessible via expressions)
  /// - [overrideIcons]: Custom icons to override defaults for this page
  /// - [overrideImages]: Custom images to override defaults for this page
  /// - [overrideTextStyles]: Custom text styles to override defaults for this page
  /// - [overrideColorTokens]: Custom colors to override defaults for this page
  /// - [navigatorKey]: Custom navigator key for page navigation
  /// - [pageController]: Custom page controller for advanced page management
  ///
  /// Returns a fully configured Flutter Widget ready to be displayed.
  ///
  /// Example:
  /// ```dart
  /// Widget checkoutPage = DUIFactory().createPage(
  ///   'checkout_page',
  ///   {'cartId': '12345', 'userId': 'user123'},
  ///   overrideColorTokens: {'primary': Colors.blue},
  /// );
  /// ```
  // Create a page with optional overriding UI resources
  Widget createPage(
    String pageId,
    JsonLike? pageArgs, {
    Map<String, IconData>? overrideIcons,
    Map<String, ImageProvider>? overrideImages,
    Map<String, TextStyle>? overrideTextStyles,
    Map<String, Color?>? overrideColorTokens,
    GlobalKey<NavigatorState>? navigatorKey,
    DUIPageController? pageController,
  }) {
    // Merge overriding resources with existing resources
    final mergedResources = UIResources(
      icons: {...?resources.icons, ...?overrideIcons},
      images: {...?resources.images, ...?overrideImages},
      textStyles: {...?resources.textStyles, ...?overrideTextStyles},
      colors: {...?resources.colors, ...?overrideColorTokens},
      darkColors: {...?resources.darkColors, ...?overrideColorTokens},
      fontFactory: resources.fontFactory,
    );

    // Get page definition from configuration
    final pageDef = configProvider.getPageDefinition(pageId);

    // Log page initialization for debugging and analytics
    // DigiaUIManager().logger?.logEntity(
    //   entitySlug: pageId,
    //   eventName: 'INITIALIZATION',
    //   argDefs: pageDef.pageArgDefs
    //           ?.map((k, v) => MapEntry(k, pageArgs?[k] ?? v.defaultValue)) ??
    //       {},
    //   initStateDefs:
    //       pageDef.initStateDefs?.map((k, v) => MapEntry(k, v.defaultValue)) ??
    //           {},
    //   stateContainerVariables: {},
    // );

    // Wrap page with action executor for handling actions
    return DefaultActionExecutor(
      actionExecutor: ActionExecutor(
        viewBuilder: (context, id, args) => _buildView(context, id, args),
        pageRouteBuilder: (context, id, args) => createPageRoute(id, args),
        bindingRegistry: bindingRegistry,
        // logger: DigiaUIManager().logger,
        executionContext: executionContext,
        // metaData: {
        //   'entitySlug': pageId,
        // },
      ),
      child: DUIPage(
        pageId: pageId,
        pageArgs: pageArgs,
        resources: mergedResources,
        navigatorKey: navigatorKey,
        pageDef: pageDef,
        registry: widgetRegistry,
        apiModels: configProvider.getAllApiModels(),
        controller: pageController,
        scope: AppStateScopeContext(
          values: DUIAppState().value,
          variables: {
            ...StdLibFunctions.functions,
            ...DigiaUIManager().jsVars,
          },
        ),
      ),
    );
  }

  /// Creates a Flutter Route for navigation to a specific page.
  ///
  /// This method wraps [createPage] in a [DUIPageRoute] for use with
  /// Flutter's navigation system. The route can be pushed onto the
  /// navigation stack using Navigator.push().
  ///
  /// Parameters are the same as [createPage].
  ///
  /// Returns a Route<Object> that can be used with Flutter navigation.
  ///
  /// Example:
  /// ```dart
  /// Navigator.push(
  ///   context,
  ///   DUIFactory().createPageRoute('profile_page', {'userId': '123'}),
  /// );
  /// ```
  Route<Object> createPageRoute(
    String pageId,
    JsonLike? pageArgs, {
    Map<String, IconData>? overrideIcons,
    Map<String, ImageProvider>? overrideImages,
    Map<String, TextStyle>? overrideTextStyles,
    Map<String, Color?>? overrideColorTokens,
    GlobalKey<NavigatorState>? navigatorKey,
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
              pageController: pageController,
            ));
  }

  /// Creates the initial page of the application based on configuration.
  ///
  /// This method retrieves the initial route from the configuration provider
  /// and creates the corresponding page widget. It's typically used as the
  /// home page of the application.
  ///
  /// Parameters allow for resource overrides similar to [createPage].
  ///
  /// Returns the initial page widget ready to be used as app home.
  ///
  /// Example:
  /// ```dart
  /// MaterialApp(
  ///   home: DUIFactory().createInitialPage(),
  /// )
  /// ```
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

  /// Internal method for building views (pages or components) based on ID.
  ///
  /// This method determines whether the given ID represents a page or component
  /// and delegates to the appropriate creation method. It's used internally
  /// by the action executor for view navigation.
  Widget _buildView(
    BuildContext context,
    String viewId,
    JsonLike? args,
  ) {
    if (configProvider.isPage(viewId)) {
      return createPage(viewId, args);
    }

    return createComponent(viewId, args);
  }

  /// Creates a reusable component widget from a JSON configuration.
  ///
  /// Components are smaller, reusable UI blocks that can be embedded within
  /// pages or other components. They have their own state management and
  /// can receive arguments for customization.
  ///
  /// Parameters:
  /// - [componentid]: Unique identifier for the component configuration
  /// - [args]: Arguments to pass to the component (accessible via expressions)
  /// - Resource override parameters (same as [createPage])
  ///
  /// Returns a fully configured component widget.
  ///
  /// Example:
  /// ```dart
  /// Widget productCard = DUIFactory().createComponent(
  ///   'product_card',
  ///   {
  ///     'title': 'iPhone 15',
  ///     'price': 999.99,
  ///     'imageUrl': 'https://...',
  ///   },
  /// );
  /// ```
  Widget createComponent(
    String componentid,
    JsonLike? args, {
    Map<String, IconData>? overrideIcons,
    Map<String, ImageProvider>? overrideImages,
    Map<String, TextStyle>? overrideTextStyles,
    Map<String, Color?>? overrideColorTokens,
    GlobalKey<NavigatorState>? navigatorKey,
    ObservabilityContext? observabilityContext,
  }) {
    // Merge overriding resources with existing resources
    final mergedResources = UIResources(
      icons: {...?resources.icons, ...?overrideIcons},
      images: {...?resources.images, ...?overrideImages},
      textStyles: {...?resources.textStyles, ...?overrideTextStyles},
      colors: {...?resources.colors, ...?overrideColorTokens},
      darkColors: {...?resources.darkColors, ...?overrideColorTokens},
      fontFactory: resources.fontFactory,
    );

    // Get component definition from configuration
    final componentDef = configProvider.getComponentDefinition(componentid);

    // Log component initialization for debugging and analytics
    // DigiaUIManager().logger?.logEntity(
    //   entitySlug: componentid,
    //   eventName: 'INITIALIZATION',
    //   argDefs: componentDef.argDefs
    //           ?.map((key, value) => MapEntry(key, value.defaultValue)) ??
    //       {},
    //   initStateDefs: componentDef.initStateDefs
    //           ?.map((key, value) => MapEntry(key, value.defaultValue)) ??
    //       {},
    //   stateContainerVariables: {},
    // );

    // Wrap component with action executor for handling actions
    return DefaultActionExecutor(
      actionExecutor: ActionExecutor(
        viewBuilder: (context, id, args) => _buildView(context, id, args),
        pageRouteBuilder: (context, id, args) => createPageRoute(id, args),
        bindingRegistry: bindingRegistry,
        // logger: DigiaUIManager().logger,
        executionContext: executionContext,
        // metaData: {
        //   'entitySlug': componentid,
        // },
      ),
      child: DUIComponent(
        id: componentid,
        args: args,
        resources: mergedResources,
        navigatorKey: navigatorKey,
        definition: componentDef,
        registry: widgetRegistry,
        apiModels: configProvider.getAllApiModels(),
        parentObservabilityContext: observabilityContext,
        scope: AppStateScopeContext(
          values: DUIAppState().value,
          variables: {
            ...StdLibFunctions.functions,
            ...DigiaUIManager().jsVars,
          },
        ),
      ),
    );
  }

  /// Shows a bottom sheet with a Digia UI view (page or component).
  ///
  /// This method creates a modal bottom sheet containing the specified view.
  /// The bottom sheet can be customized with various styling options and
  /// supports automatic height calculation based on content.
  ///
  /// Parameters:
  /// - [context]: BuildContext for showing the bottom sheet
  /// - [viewId]: ID of the view to display in the bottom sheet
  /// - [args]: Arguments to pass to the view
  /// - [scrollControlDisabledMaxHeightRatio]: Maximum height ratio when scroll is disabled
  /// - [backgroundColor]: Background color of the bottom sheet
  /// - [barrierColor]: Color of the barrier behind the bottom sheet
  /// - [border]: Border styling for the bottom sheet
  /// - [borderRadius]: Border radius for the bottom sheet corners
  /// - [iconBuilder]: Optional builder for custom close icon
  /// - [useSafeArea]: Whether to respect device safe areas
  /// - [navigatorKey]: Custom navigator key
  ///
  /// Returns a Future that completes when the bottom sheet is dismissed,
  /// optionally with a result value of type T.
  ///
  /// Example:
  /// ```dart
  /// final result = await DUIFactory().showBottomSheet<String>(
  ///   context,
  ///   'filter_options',
  ///   {'category': 'electronics'},
  ///   backgroundColor: Colors.white,
  ///   borderRadius: BorderRadius.circular(16),
  /// );
  /// ```
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
    bool useSafeArea = true,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return presentBottomSheet(
      context: context,
      builder: (innerCtx) => _buildView(innerCtx, viewId, args),
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      border: border,
      borderRadius: borderRadius,
      useSafeArea: useSafeArea,
      iconBuilder: iconBuilder,
      navigatorKey: navigatorKey,
    );
  }
}

/// Container class for all UI resources used by the Digia UI system.
///
/// [UIResources] holds mappings for icons, images, text styles, colors,
/// and font factories that can be used throughout the application.
/// This allows for centralized resource management and easy customization.
class UIResources {
  /// Mapping of icon names to IconData objects for use in UI components
  final Map<String, IconData>? icons;

  /// Mapping of image names to ImageProvider objects for use in UI components
  final Map<String, ImageProvider>? images;

  /// Mapping of text style names to TextStyle objects for consistent typography
  final Map<String, TextStyle?>? textStyles;

  /// Mapping of color token names to Color objects for light theme
  final Map<String, Color?>? colors;

  /// Mapping of color token names to Color objects for dark theme
  final Map<String, Color?>? darkColors;

  /// Factory for creating custom fonts and text styles
  final DUIFontFactory? fontFactory;

  /// Creates a new UIResources instance with the provided resource mappings.
  UIResources({
    required this.icons,
    required this.images,
    required this.textStyles,
    required this.colors,
    required this.darkColors,
    this.fontFactory,
  });
}
