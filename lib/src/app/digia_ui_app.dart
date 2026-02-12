import 'package:flutter/widgets.dart';

import '../analytics/dui_analytics.dart';
import '../config/app_state/global_state.dart';
import '../framework/digia_ui_scope.dart';
import '../framework/font_factory.dart';
import '../framework/message_bus.dart';
import '../framework/page/config_provider.dart';
import '../framework/ui_factory.dart';
import '../init/digia_ui.dart';
import '../init/digia_ui_manager.dart';

/// The main application wrapper for integrating Digia UI SDK into Flutter applications.
///
/// [DigiaUIApp] serves as the root widget that manages the lifecycle of the Digia UI system
/// and provides a scope for analytics, messaging, and other core functionalities.
///
/// This widget handles:
/// - Initialization and disposal of the Digia UI system
/// - Global app state management
/// - UI factory setup with custom resources
/// - Analytics and message bus integration
/// - Environment variable configuration
/// - Providing Digia UI context to child widgets
///
/// Example usage:
/// ```dart
/// DigiaUIApp(
///   digiaUI: await DigiaUI.initialize(config),
///   analytics: MyAnalyticsHandler(),
///   messageBus: MyMessageBus(),
///   icons: customIcons,
///   environmentVariables: {'authToken': '1234567890'},
///   builder: (context) => MaterialApp(
///     home: DUIFactory().createInitialPage(),
///   ),
/// )
/// ```
class DigiaUIApp extends StatefulWidget {
  /// The initialized DigiaUI instance containing configuration and resources
  final DigiaUI digiaUI;

  /// Optional analytics handler for tracking user interactions and events
  final DUIAnalytics? analytics;

  /// Optional message bus for inter-component communication
  final MessageBus? messageBus;

  /// Custom page configuration provider, defaults to built-in provider if not specified
  final ConfigProvider? pageConfigProvider;

  /// Custom icon mappings to override or extend default icons
  final Map<String, IconData>? icons;

  /// Custom image provider mappings for app-specific images
  final Map<String, ImageProvider<Object>>? images;

  /// Custom font factory for creating text styles with specific fonts
  final DUIFontFactory? fontFactory;

  /// Environment variables to make available in expressions and configurations
  final Map<String, Object?>? environmentVariables;

  /// Builder function that creates the child widget tree with access to BuildContext
  final Widget Function(BuildContext context) builder;

  /// Creates a new [DigiaUIApp] with the specified configuration.
  ///
  /// The [digiaUI] parameter must be an initialized instance obtained from
  /// `DigiaUI.initialize()`. The [builder] function will be called to create
  /// the child widget tree once the Digia UI system is ready.
  const DigiaUIApp({
    super.key,
    required this.digiaUI,
    this.messageBus,
    this.analytics,
    this.pageConfigProvider,
    this.icons,
    this.images,
    this.fontFactory,
    this.environmentVariables,
    required this.builder,
  });

  @override
  State<DigiaUIApp> createState() => _DigiaUIAppState();
}

class _DigiaUIAppState extends State<DigiaUIApp> {
  @override
  void initState() {
    // Initialize the Digia UI manager with the provided configuration
    DigiaUIManager().initialize(widget.digiaUI);

    // Initialize global app state with configuration from DSL
    DUIAppState().init(widget.digiaUI.dslConfig.appState ?? []);

    // Set up the UI factory with custom resources and providers
    DUIFactory().initialize(
      pageConfigProvider: widget.pageConfigProvider,
      icons: widget.icons,
      images: {
        ...(DigiaUIManager().assetImages.asMap().map((k, v) => MapEntry(
            v.assetData.localPath,
            NetworkImage(
                '${v.assetData.image?.baseUrl}${v.assetData.image?.path}')))),
        ...?widget.images
      },
      fontFactory: widget.fontFactory,
    );

    // Apply environment variables from DigiaUIApp if provided
    if (widget.environmentVariables != null) {
      DUIFactory().setEnvironmentVariables(widget.environmentVariables!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the child widget tree with DigiaUIScope to provide
    // analytics and message bus context to all descendant widgets
    return DigiaUIScope(
      analyticsHandler: widget.analytics,
      messageBus: widget.messageBus,
      child: widget.builder(context),
    );
  }

  @override
  void dispose() {
    // Clean up all Digia UI resources when the widget is disposed
    DigiaUIManager().destroy();
    DUIAppState().dispose();
    DUIFactory().destroy();
    super.dispose();
  }
}
