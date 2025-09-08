# Multi-Instance Dependency Injection Solution for DigiaUI SDK

## Problem Statement

The current DigiaUI SDK uses multiple singletons that prevent having multiple instances of DigiaUI in a single application:

- `DigiaUIManager` (singleton) - holds the main DigiaUI instance
- `DUIFactory` (singleton) - manages UI creation and resources  
- `DUIAppState` (singleton) - manages global state
- `PreferencesStore` (singleton) - handles persistence

**Requirement**: Support multiple DigiaUI instances while avoiding singletons and providing dependency injection for services like Logger that need to be accessible without BuildContext.

## Solution Overview

**Scoped Service Locator Pattern** - Each DigiaUI instance gets its own dependency injection scope, eliminating singletons while providing both context-based and direct service access.

## Core Infrastructure

### 1. DigiaUIScope - Scoped Service Container

```dart
/// Scoped dependency injection container for DigiaUI instances
class DigiaUIScope {
  final String instanceId;
  final Map<Type, Object> _services = {};
  
  DigiaUIScope(this.instanceId);
  
  /// Register a service in this scope
  void register<T>(T service) {
    _services[T] = service;
  }
  
  /// Get a service from this scope
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw StateError('Service $T not registered in scope $instanceId');
    }
    return service as T;
  }
  
  /// Check if service exists
  bool has<T>() => _services.containsKey(T);
  
  /// Get service safely (returns null if not found)
  T? tryGet<T>() {
    final service = _services[T];
    return service as T?;
  }
  
  /// Dispose all services that implement Disposable
  void dispose() {
    for (final service in _services.values) {
      if (service is Disposable) {
        service.dispose();
      }
    }
    _services.clear();
  }
  
  /// Get all registered service types
  Set<Type> get registeredTypes => _services.keys.toSet();
}
```

### 2. Disposable Interface

```dart
/// Interface for services that need cleanup
abstract class Disposable {
  void dispose();
}
```

### 3. DigiaUIProvider - Context Access

```dart
/// InheritedWidget to provide DigiaUI scope down the widget tree
class DigiaUIProvider extends InheritedWidget {
  final DigiaUIScope scope;
  
  const DigiaUIProvider({
    Key? key,
    required this.scope,
    required Widget child,
  }) : super(key: key, child: child);
  
  static DigiaUIScope of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<DigiaUIProvider>();
    if (provider == null) {
      throw FlutterError('DigiaUIProvider not found in context');
    }
    return provider.scope;
  }
  
  /// Convenience method to get services
  static T getService<T>(BuildContext context) {
    return of(context).get<T>();
  }
  
  /// Safe service access that returns null if not found
  static T? tryGetService<T>(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<DigiaUIProvider>();
    return provider?.scope.tryGet<T>();
  }
  
  @override
  bool updateShouldNotify(DigiaUIProvider oldWidget) {
    return scope != oldWidget.scope;
  }
}
```

## Scoped Services Implementation

### 1. Scoped Preferences Store

```dart
class ScopedPreferencesStore implements Disposable {
  final String instanceId;
  final String keyPrefix;
  late SharedPreferences prefs;
  
  ScopedPreferencesStore(this.instanceId) 
    : keyPrefix = 'digia_ui_${instanceId}.';
  
  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }
  
  String _addPrefix(String key) => '$keyPrefix$key';
  
  T? read<T>(String key, [T? defaultValue]) {
    final prefixedKey = _addPrefix(key);
    final value = prefs.get(prefixedKey);

    if (value == null) return defaultValue;

    if (T == String) return value as T?;
    if (T == int) return value as T?;
    if (T == double) return value as T?;
    if (T == bool) return value as T?;

    // For complex objects, try to decode JSON if it's a string
    if (value is String) {
      final decoded = tryJsonDecode(value);
      return decoded as T? ?? defaultValue;
    }

    return value as T? ?? defaultValue;
  }
  
  Future<bool> write<T>(String key, T value) async {
    final prefixedKey = _addPrefix(key);

    if (value is String) {
      return prefs.setString(prefixedKey, value);
    } else if (value is int) {
      return prefs.setInt(prefixedKey, value);
    } else if (value is double) {
      return prefs.setDouble(prefixedKey, value);
    } else if (value is bool) {
      return prefs.setBool(prefixedKey, value);
    } else {
      // For complex objects, encode as JSON string
      final jsonString = jsonEncode(value);
      return prefs.setString(prefixedKey, jsonString);
    }
  }
  
  Future<bool> delete(String key) {
    return prefs.remove(_addPrefix(key));
  }
  
  Future<bool> clear() async {
    final keys = prefs.getKeys().where((key) => key.startsWith(keyPrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
    return true;
  }
  
  bool contains(String key) {
    return prefs.containsKey(_addPrefix(key));
  }
  
  Set<String> getKeys() {
    return prefs
        .getKeys()
        .where((key) => key.startsWith(keyPrefix))
        .map((key) => key.substring(keyPrefix.length))
        .toSet();
  }
  
  @override
  void dispose() {
    // Cleanup if needed - SharedPreferences doesn't need disposal
  }
}
```

### 2. Scoped App State

```dart
class ScopedDUIAppState implements Disposable {
  final String instanceId;
  final Map<String, ReactiveValue<Object?>> _values = {};
  bool _isInitialized = false;
  
  ScopedDUIAppState(this.instanceId);
  
  /// Initialize the scoped state with SharedPreferences and state descriptors
  Future<void> init(List<dynamic> values, ScopedPreferencesStore prefsStore) async {
    if (_isInitialized) {
      dispose();
    }

    final descriptors = values.map((e) => StateDescriptorFactory().fromJson(e)).toList();

    for (final descriptor in descriptors) {
      if (_values.containsKey(descriptor.key)) {
        throw Exception('Duplicate state key: ${descriptor.key}');
      }

      // Create either PersistedReactiveValue or ReactiveValue based on shouldPersist
      final value = DefaultReactiveValueFactory().create(
        descriptor,
        prefsStore.prefs,
      );

      _values[descriptor.key] = value;
    }

    _isInitialized = true;
  }
  
  /// Get a reactive value by key
  ReactiveValue<T> get<T>(String key) {
    if (!_isInitialized) {
      throw Exception('ScopedDUIAppState must be initialized before getting values');
    }

    if (!_values.containsKey(key)) {
      throw Exception('State key "$key" not found');
    }

    final value = _values[key];
    if (value is! ReactiveValue<T>) {
      throw Exception('Type mismatch for key "$key"');
    }

    return value;
  }
  
  /// Get the current value by key
  T getValue<T>(String key) => get<T>(key).value;
  
  Map<String, ReactiveValue<Object?>> get value => _values;
  
  /// Update a value by key
  bool setValue<T>(String key, T newValue) => get<T>(key).update(newValue);
  
  /// Listen to changes of a value
  StreamSubscription<T> listen<T>(String key, void Function(T) onData) {
    return get<T>(key).controller.stream.listen(onData);
  }
  
  @override
  void dispose() {
    for (final value in _values.values) {
      value.dispose();
    }
    _values.clear();
    _isInitialized = false;
  }
}
```

### 3. Scoped DUI Factory

```dart
class ScopedDUIFactory implements Disposable {
  final DigiaUIScope _scope;
  late ConfigProvider configProvider;
  late UIResources resources;
  late VirtualWidgetRegistry widgetRegistry;
  late MethodBindingRegistry bindingRegistry;
  
  ScopedDUIFactory(this._scope);
  
  void initialize(
    DigiaUI digiaUI, {
    ConfigProvider? pageConfigProvider,
    Map<String, IconData>? icons,
    Map<String, ImageProvider>? images,
    DUIFontFactory? fontFactory,
  }) {
    // Get scoped dependencies
    final prefsStore = _scope.get<ScopedPreferencesStore>();
    final appState = _scope.get<ScopedDUIAppState>();
    
    // Initialize widget registry with component builder
    widgetRegistry = DefaultVirtualWidgetRegistry(
      componentBuilder: (id, args) => createComponent(id, args),
    );

    // Initialize method binding registry for expression evaluation
    bindingRegistry = MethodBindingRegistry();

    // Set up configuration provider (use custom or default)
    configProvider = pageConfigProvider ?? DUIConfigProvider(digiaUI.dslConfig);

    // Build UI resources from configuration and custom overrides
    resources = UIResources(
      icons: icons,
      images: images,
      textStyles: digiaUI.dslConfig.fontTokens.map((key, value) => MapEntry(
        key,
        convertToTextStyle(value, fontFactory),
      )),
      fontFactory: fontFactory,
      colors: digiaUI.dslConfig.colorTokens.map(
        (key, value) => MapEntry(
          key,
          as$<String>(value).maybe(ColorUtil.fromString),
        ),
      ),
      darkColors: digiaUI.dslConfig.darkColorTokens.map(
        (key, value) => MapEntry(
          key,
          as$<String>(value).maybe(ColorUtil.fromString),
        ),
      ),
    );
  }
  
  /// Sets a single environment variable value at runtime
  void setEnvironmentVariable(String varName, Object? value) {
    final digiaUI = _scope.get<DigiaUI>();
    digiaUI.dslConfig.setEnvVariable(varName, value);
  }
  
  /// Sets multiple environment variables at once
  void setEnvironmentVariables(Map<String, Object?> variables) {
    final digiaUI = _scope.get<DigiaUI>();
    for (final entry in variables.entries) {
      digiaUI.dslConfig.setEnvVariable(entry.key, entry.value);
    }
  }
  
  /// Clears a single environment variable
  void clearEnvironmentVariable(String varName) {
    final digiaUI = _scope.get<DigiaUI>();
    digiaUI.dslConfig.setEnvVariable(varName, null);
  }
  
  /// Clears multiple environment variables
  void clearEnvironmentVariables(List<String> varNames) {
    final digiaUI = _scope.get<DigiaUI>();
    for (final varName in varNames) {
      digiaUI.dslConfig.setEnvVariable(varName, null);
    }
  }
  
  /// Register a new widget type with type-safe properties
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
  
  /// Register a new widget type that works directly with JSON properties
  void registerJsonWidget(
    String type,
    VirtualWidget Function(
      JsonLike props,
      Map<String, List<VirtualWidget>>? childGroups,
    ) builder,
  ) {
    widgetRegistry.registerJsonWidget(type, builder);
  }
  
  /// Create a page widget with scoped dependencies
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
    final appState = _scope.get<ScopedDUIAppState>();
    final logger = _scope.tryGet<DUILogger>();
    
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
    logger?.logEntity(
      entitySlug: pageId,
      eventName: 'INITIALIZATION',
      argDefs: pageDef.pageArgDefs
              ?.map((k, v) => MapEntry(k, pageArgs?[k] ?? v.defaultValue)) ??
          {},
      initStateDefs:
          pageDef.initStateDefs?.map((k, v) => MapEntry(k, v.defaultValue)) ??
              {},
      stateContainerVariables: {},
    );

    // Wrap page with action executor for handling actions
    return DefaultActionExecutor(
      actionExecutor: ActionExecutor(
        viewBuilder: (context, id, args) => _buildView(context, id, args),
        pageRouteBuilder: (context, id, args) => createPageRoute(id, args),
        bindingRegistry: bindingRegistry,
        logger: logger,
        metaData: {
          'entitySlug': pageId,
        },
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
          values: appState.value,
          variables: {
            ...StdLibFunctions.functions,
            ..._getJsVars(),
          },
        ),
      ),
    );
  }
  
  /// Create a Flutter Route for navigation
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
      ),
    );
  }
  
  /// Create the initial page of the application
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
  
  /// Create a component widget
  Widget createComponent(
    String componentId,
    JsonLike? args, {
    Map<String, IconData>? overrideIcons,
    Map<String, ImageProvider>? overrideImages,
    Map<String, TextStyle>? overrideTextStyles,
    Map<String, Color?>? overrideColorTokens,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    final appState = _scope.get<ScopedDUIAppState>();
    final logger = _scope.tryGet<DUILogger>();
    
    // Similar implementation to createPage but for components
    final mergedResources = UIResources(
      icons: {...?resources.icons, ...?overrideIcons},
      images: {...?resources.images, ...?overrideImages},
      textStyles: {...?resources.textStyles, ...?overrideTextStyles},
      colors: {...?resources.colors, ...?overrideColorTokens},
      darkColors: {...?resources.darkColors, ...?overrideColorTokens},
      fontFactory: resources.fontFactory,
    );

    final componentDef = configProvider.getComponentDefinition(componentId);

    logger?.logEntity(
      entitySlug: componentId,
      eventName: 'INITIALIZATION',
      argDefs: componentDef.argDefs
              ?.map((key, value) => MapEntry(key, value.defaultValue)) ??
          {},
      initStateDefs: componentDef.initStateDefs
              ?.map((key, value) => MapEntry(key, value.defaultValue)) ??
          {},
      stateContainerVariables: {},
    );

    return DefaultActionExecutor(
      actionExecutor: ActionExecutor(
        viewBuilder: (context, id, args) => _buildView(context, id, args),
        pageRouteBuilder: (context, id, args) => createPageRoute(id, args),
        bindingRegistry: bindingRegistry,
        logger: logger,
        metaData: {
          'entitySlug': componentId,
        },
      ),
      child: DUIComponent(
        id: componentId,
        args: args,
        resources: mergedResources,
        navigatorKey: navigatorKey,
        definition: componentDef,
        registry: widgetRegistry,
        apiModels: configProvider.getAllApiModels(),
        scope: AppStateScopeContext(
          values: appState.value,
          variables: {
            ...StdLibFunctions.functions,
            ..._getJsVars(),
          },
        ),
      ),
    );
  }
  
  /// Show bottom sheet with scoped view
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
  
  /// Internal method for building views
  Widget _buildView(BuildContext context, String viewId, JsonLike? args) {
    if (configProvider.isPage(viewId)) {
      return createPage(viewId, args);
    }
    return createComponent(viewId, args);
  }
  
  /// Get JS variables for expression evaluation
  Map<String, Object?> _getJsVars() {
    final digiaUI = _scope.get<DigiaUI>();
    return {
      'js': ExprClassInstance(
        klass: ExprClass(name: 'js', fields: {}, methods: {
          'eval': ExprCallableImpl(
            fn: (evaluator, arguments) {
              return digiaUI.dslConfig.jsFunctions?.callJs(
                _toValue<String>(evaluator, arguments[0])!,
                arguments
                    .skip(1)
                    .map((e) => _toValue(evaluator, e))
                    .toList(),
              );
            },
            arity: 2,
          )
        }),
      )
    };
  }
  
  T? _toValue<T>(evaluator, Object obj) {
    if (obj is ASTNode) {
      final result = evaluator.eval(obj);
      return result as T?;
    }
    return obj as T?;
  }
  
  @override
  void dispose() {
    widgetRegistry.dispose();
    bindingRegistry.dispose();
  }
}
```

## Refactored DigiaUI Class

```dart
class DigiaUI implements Disposable {
  final DigiaUIOptions initConfig;
  final NetworkClient networkClient;
  final DUIConfig dslConfig;
  final DigiaUIScope _scope;
  
  /// Unique identifier for this DigiaUI instance
  String get instanceId => _scope.instanceId;
  
  DigiaUI._(
    this.initConfig,
    this.networkClient,
    this.dslConfig,
    this._scope,
  );
  
  /// Initialize a new DigiaUI instance with its own scope
  static Future<DigiaUI> initialize(
    DigiaUIOptions options, {
    String? instanceId,
    ConfigProvider? pageConfigProvider,
    Map<String, IconData>? icons,
    Map<String, ImageProvider>? images,
    DUIFontFactory? fontFactory,
  }) async {
    // Generate unique instance ID if not provided
    final id = instanceId ?? 'digia_ui_${DateTime.now().millisecondsSinceEpoch}';
    final scope = DigiaUIScope(id);
    
    // Create scoped preferences store
    final prefsStore = ScopedPreferencesStore(id);
    await prefsStore.initialize();
    scope.register<ScopedPreferencesStore>(prefsStore);
    
    // Create network client and config
    final headers = await _createDigiaHeaders(options, '');
    final networkClient = NetworkClient(
      options.developerConfig.baseUrl,
      headers,
      options.networkConfiguration ?? NetworkConfiguration.withDefaults(),
      options.developerConfig,
    );
    
    final config = await ConfigResolver(options.flavor, networkClient).getConfig();
    
    // Create DigiaUI instance first so it can be registered in scope
    final digiaUI = DigiaUI._(options, networkClient, config, scope);
    scope.register<DigiaUI>(digiaUI);
    
    // Register logger if provided
    if (options.developerConfig.logger != null) {
      scope.register<DUILogger>(options.developerConfig.logger!);
    }
    
    // Create scoped app state
    final appState = ScopedDUIAppState(id);
    await appState.init(config.globalState ?? [], prefsStore);
    scope.register<ScopedDUIAppState>(appState);
    
    // Create and initialize scoped factory
    final factory = ScopedDUIFactory(scope);
    factory.initialize(
      digiaUI,
      pageConfigProvider: pageConfigProvider,
      icons: icons,
      images: images,
      fontFactory: fontFactory,
    );
    scope.register<ScopedDUIFactory>(factory);
    
    // Set up state observer if provided
    if (options.developerConfig.inspector?.stateObserver != null) {
      // TODO: R1.0 - Update state observer to work with scoped state
    }
    
    return digiaUI;
  }
  
  /// Get a service from this instance's scope
  T getService<T>() => _scope.get<T>();
  
  /// Try to get a service from this instance's scope (returns null if not found)
  T? tryGetService<T>() => _scope.tryGet<T>();
  
  /// Check if a service is registered in this instance's scope
  bool hasService<T>() => _scope.has<T>();
  
  /// Get the dependency injection scope for this instance
  DigiaUIScope get scope => _scope;
  
  /// Create default Digia headers for API communication
  static Future<Map<String, dynamic>> _createDigiaHeaders(
    DigiaUIOptions options,
    String? uuid,
  ) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var packageName = packageInfo.packageName;
    var appVersion = packageInfo.version;
    var appbuildNumber = packageInfo.buildNumber;
    var appSignatureSha256 = packageInfo.buildSignature;

    return NetworkClient.getDefaultDigiaHeaders(
      packageVersion,
      options.accessKey,
      _getPlatform(),
      uuid,
      packageName,
      appVersion,
      appbuildNumber,
      options.flavor.environment.name,
      appSignatureSha256,
    );
  }
  
  /// Determine current platform for API communication
  static String _getPlatform() {
    if (kIsWeb) return 'mobile_web';
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'mobile_web';
  }
  
  @override
  void dispose() {
    _scope.dispose();
  }
}
```

## Updated App Integration

### 1. DigiaUIApp (Eager Initialization)

```dart
class DigiaUIApp extends StatelessWidget {
  final DigiaUI digiaUI;
  final Widget Function(BuildContext context) builder;

  const DigiaUIApp({
    Key? key,
    required this.digiaUI,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DigiaUIProvider(
      scope: digiaUI.scope,
      child: builder(context),
    );
  }
}
```

### 2. DigiaUIAppBuilder (Lazy Initialization)

```dart
enum DigiaUIStatus { loading, ready, error }

class DigiaUIAppStatus {
  final DigiaUIStatus status;
  final DigiaUI? digiaUI;
  final Object? error;

  const DigiaUIAppStatus({
    required this.status,
    this.digiaUI,
    this.error,
  });

  bool get isLoading => status == DigiaUIStatus.loading;
  bool get isReady => status == DigiaUIStatus.ready;
  bool get hasError => status == DigiaUIStatus.error;
}

class DigiaUIAppBuilder extends StatefulWidget {
  final DigiaUIOptions options;
  final Widget Function(BuildContext context, DigiaUIAppStatus status) builder;
  final String? instanceId;
  final ConfigProvider? pageConfigProvider;
  final Map<String, IconData>? icons;
  final Map<String, ImageProvider>? images;
  final DUIFontFactory? fontFactory;

  const DigiaUIAppBuilder({
    Key? key,
    required this.options,
    required this.builder,
    this.instanceId,
    this.pageConfigProvider,
    this.icons,
    this.images,
    this.fontFactory,
  }) : super(key: key);

  @override
  State<DigiaUIAppBuilder> createState() => _DigiaUIAppBuilderState();
}

class _DigiaUIAppBuilderState extends State<DigiaUIAppBuilder> {
  DigiaUIAppStatus _status = const DigiaUIAppStatus(status: DigiaUIStatus.loading);

  @override
  void initState() {
    super.initState();
    _initializeDigiaUI();
  }

  Future<void> _initializeDigiaUI() async {
    try {
      final digiaUI = await DigiaUI.initialize(
        widget.options,
        instanceId: widget.instanceId,
        pageConfigProvider: widget.pageConfigProvider,
        icons: widget.icons,
        images: widget.images,
        fontFactory: widget.fontFactory,
      );
      
      if (mounted) {
        setState(() {
          _status = DigiaUIAppStatus(
            status: DigiaUIStatus.ready,
            digiaUI: digiaUI,
          );
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _status = DigiaUIAppStatus(
            status: DigiaUIStatus.error,
            error: error,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_status.isReady) {
      return DigiaUIProvider(
        scope: _status.digiaUI!.scope,
        child: widget.builder(context, _status),
      );
    }
    
    return widget.builder(context, _status);
  }
  
  @override
  void dispose() {
    _status.digiaUI?.dispose();
    super.dispose();
  }
}
```

## Usage Examples

### 1. Multiple Instance Setup

```dart
void main() async {
  // Create multiple DigiaUI instances
  final mainDigiaUI = await DigiaUI.initialize(
    mainAppOptions,
    instanceId: 'main_app',
  );
  
  final adminDigiaUI = await DigiaUI.initialize(
    adminAppOptions, 
    instanceId: 'admin_panel',
  );
  
  runApp(MultiInstanceApp(
    mainDigiaUI: mainDigiaUI,
    adminDigiaUI: adminDigiaUI,
  ));
}

class MultiInstanceApp extends StatefulWidget {
  final DigiaUI mainDigiaUI;
  final DigiaUI adminDigiaUI;
  
  const MultiInstanceApp({
    Key? key,
    required this.mainDigiaUI,
    required this.adminDigiaUI,
  }) : super(key: key);

  @override
  State<MultiInstanceApp> createState() => _MultiInstanceAppState();
}

class _MultiInstanceAppState extends State<MultiInstanceApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Multi-Instance DigiaUI'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Main App'),
              Tab(text: 'Admin Panel'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Main app with its own scope
            DigiaUIProvider(
              scope: widget.mainDigiaUI.scope,
              child: widget.mainDigiaUI
                  .getService<ScopedDUIFactory>()
                  .createInitialPage(),
            ),
            // Admin panel with separate scope
            DigiaUIProvider(
              scope: widget.adminDigiaUI.scope,
              child: widget.adminDigiaUI
                  .getService<ScopedDUIFactory>()
                  .createInitialPage(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    widget.mainDigiaUI.dispose();
    widget.adminDigiaUI.dispose();
    super.dispose();
  }
}
```

### 2. Single Instance with Lazy Loading

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DigiaUIAppBuilder(
      options: DigiaUIOptions(
        accessKey: 'YOUR_ACCESS_KEY',
        flavor: Flavor.release(
          initStrategy: NetworkFirstStrategy(timeoutInMs: 2000),
          appConfigPath: 'assets/config.json',
          functionsPath: 'assets/functions.js',
        ),
      ),
      builder: (context, status) {
        if (status.isReady) {
          return MaterialApp(
            home: DigiaUIProvider.getService<ScopedDUIFactory>(context)
                .createInitialPage(),
          );
        }
        
        if (status.isLoading) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Error: ${status.error}'),
            ),
          ),
        );
      },
    );
  }
}
```

### 3. Widget Access Patterns

#### Context-Based Access (Recommended)
```dart
class MyCustomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access services via context when BuildContext is available
    final factory = DigiaUIProvider.getService<ScopedDUIFactory>(context);
    final appState = DigiaUIProvider.getService<ScopedDUIAppState>(context);
    final logger = DigiaUIProvider.tryGetService<DUILogger>(context);
    
    return Column(
      children: [
        Text('Instance: ${DigiaUIProvider.of(context).instanceId}'),
        ElevatedButton(
          onPressed: () {
            // Use scoped services
            appState.setValue('buttonPressed', true);
            logger?.log('Button pressed');
            
            // Navigate to another page
            Navigator.push(
              context,
              factory.createPageRoute('details_page', {'from': 'button'}),
            );
          },
          child: Text('Navigate'),
        ),
      ],
    );
  }
}
```

#### Direct Scope Access (For Non-Widget Classes)
```dart
class MyService {
  final DigiaUIScope scope;
  
  MyService(this.scope);
  
  void performAction() {
    // Access services without BuildContext
    final factory = scope.get<ScopedDUIFactory>();
    final appState = scope.get<ScopedDUIAppState>();
    final logger = scope.tryGet<DUILogger>();
    
    // Update app state
    appState.setValue('lastAction', DateTime.now().toIso8601String());
    
    // Log the action
    logger?.log('Action performed by service');
    
    // Set environment variables
    factory.setEnvironmentVariable('lastServiceCall', DateTime.now().millisecondsSinceEpoch);
  }
}
```

#### Action System Integration
```dart
class CustomActionProcessor extends ActionProcessor {
  @override
  Future<ActionResult> process(
    ActionPayload actionPayload,
    RenderPayload renderPayload,
  ) async {
    // Get scope from render payload context
    final scope = DigiaUIProvider.of(renderPayload.context);
    
    // Access scoped services
    final appState = scope.get<ScopedDUIAppState>();
    final logger = scope.tryGet<DUILogger>();
    
    // Perform action with scoped dependencies
    appState.setValue('customAction', actionPayload.data);
    logger?.logAction('custom_action', actionPayload.data);
    
    return ActionResult.success();
  }
}
```

### 4. Testing with Scoped Dependencies

```dart
void main() {
  group('DigiaUI Multi-Instance Tests', () {
    late DigiaUI digiaUI1;
    late DigiaUI digiaUI2;
    
    setUp(() async {
      digiaUI1 = await DigiaUI.initialize(
        testOptions1,
        instanceId: 'test_instance_1',
      );
      
      digiaUI2 = await DigiaUI.initialize(
        testOptions2,
        instanceId: 'test_instance_2',
      );
    });
    
    tearDown(() {
      digiaUI1.dispose();
      digiaUI2.dispose();
    });
    
    test('instances have separate scopes', () {
      expect(digiaUI1.instanceId, isNot(equals(digiaUI2.instanceId)));
      expect(digiaUI1.scope, isNot(equals(digiaUI2.scope)));
    });
    
    test('instances have separate app state', () {
      final appState1 = digiaUI1.getService<ScopedDUIAppState>();
      final appState2 = digiaUI2.getService<ScopedDUIAppState>();
      
      appState1.setValue('testKey', 'value1');
      appState2.setValue('testKey', 'value2');
      
      expect(appState1.getValue('testKey'), equals('value1'));
      expect(appState2.getValue('testKey'), equals('value2'));
    });
    
    test('instances have separate preferences', () {
      final prefs1 = digiaUI1.getService<ScopedPreferencesStore>();
      final prefs2 = digiaUI2.getService<ScopedPreferencesStore>();
      
      expect(prefs1.keyPrefix, contains('test_instance_1'));
      expect(prefs2.keyPrefix, contains('test_instance_2'));
    });
  });
}
```

## Migration Path

### Phase 1: Core Infrastructure (Week 1)
- [ ] Create `DigiaUIScope` class
- [ ] Create `Disposable` interface  
- [ ] Create `DigiaUIProvider` InheritedWidget
- [ ] Add comprehensive tests for scope management

### Phase 2: Scoped Services (Week 2)
- [ ] Implement `ScopedPreferencesStore`
- [ ] Implement `ScopedDUIAppState`
- [ ] Implement `ScopedDUIFactory`
- [ ] Update existing service interfaces to support scoped access

### Phase 3: DigiaUI Integration (Week 3)
- [ ] Refactor `DigiaUI.initialize()` to create scoped dependencies
- [ ] Add instance ID support and scope management
- [ ] Add `getService<T>()` method and `dispose()` cleanup
- [ ] Update `DigiaUIManager` to be scoped (or remove if no longer needed)

### Phase 4: Widget Tree Updates (Week 4)
- [ ] Update `DigiaUIApp` to use `DigiaUIProvider`
- [ ] Update `DigiaUIAppBuilder` to support lazy initialization
- [ ] Update all existing widget access patterns
- [ ] Update action processors to use scoped services

### Phase 5: Migration & Testing (Week 5)
- [ ] Update all singleton references throughout codebase
- [ ] Add comprehensive integration tests for multi-instance scenarios
- [ ] Update documentation with new usage patterns
- [ ] Performance testing with multiple instances

## Benefits

1. **No More Singletons**: Each DigiaUI instance has its own scoped services
2. **Clean Separation**: Multiple instances don't interfere with each other  
3. **Context-Aware**: Services available both via BuildContext and direct scope access
4. **Backward Compatible**: Minimal changes to existing widget code
5. **Resource Management**: Proper disposal prevents memory leaks
6. **Flexible**: Easy to add new scoped services
7. **Testable**: Easy to mock and test individual instances
8. **Type Safe**: Compile-time safety for service access

## Considerations

- **Memory Usage**: Multiple instances will use more memory
- **Initialization Time**: Each instance needs separate initialization
- **State Synchronization**: No automatic sync between instances (by design)
- **Migration Effort**: Requires updating all singleton access patterns
- **Testing**: Need comprehensive tests for multi-instance scenarios

This solution provides a clean, scalable approach to dependency injection that eliminates singletons while supporting multiple DigiaUI instances in a single application.