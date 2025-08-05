import 'package:flutter/widgets.dart';

import '../analytics/dui_analytics.dart';
import '../framework/font_factory.dart';
import '../framework/message_bus.dart';
import '../framework/page/config_provider.dart';
import '../init/config.dart';
import '../init/digia_ui.dart';
import 'digia_ui_app.dart';

/// A widget that handles the asynchronous initialization of the Digia UI system.
///
/// [DigiaUIAppBuilder] provides a builder pattern that allows you to handle different
/// states during the initialization process (loading, ready, error). This is the
/// recommended way to initialize Digia UI as it properly manages the async initialization
/// flow and provides appropriate feedback to users.
///
/// The widget will:
/// - Show loading state while initializing
/// - Transition to ready state with DigiaUIApp when initialization succeeds
/// - Show error state if initialization fails
///
/// Example usage:
/// ```dart
/// DigiaUIAppBuilder(
///   options: InitConfig(
///     accessKey: 'YOUR_ACCESS_KEY',
///     flavor: Flavor.production(),
///   ),
///   builder: (context, status) {
///     if (status.isLoading) {
///       return LoadingScreen();
///     }
///     if (status.hasError) {
///       return ErrorScreen(error: status.error);
///     }
///     return MaterialApp(
///       home: DUIFactory().createInitialPage(),
///     );
///   },
/// )
/// ```
class DigiaUIAppBuilder extends StatefulWidget {
  /// Configuration options for initializing the Digia UI system
  final InitConfig options;

  /// Builder function that receives the current initialization status
  /// and should return appropriate widgets for each state
  final Widget Function(BuildContext context, DigiaUIStatus status) builder;

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

  /// Creates a new [DigiaUIAppBuilder] with the specified configuration.
  ///
  /// The [options] parameter contains initialization settings including
  /// access keys, environment configuration, and other setup parameters.
  /// The [builder] function will be called with different [DigiaUIStatus]
  /// values as initialization progresses.
  const DigiaUIAppBuilder({
    super.key,
    required this.options,
    required this.builder,
    this.messageBus,
    this.analytics,
    this.pageConfigProvider,
    this.icons,
    this.images,
    this.fontFactory,
  });

  @override
  State<DigiaUIAppBuilder> createState() => _DigiaUIAppBuilderState();
}

class _DigiaUIAppBuilderState extends State<DigiaUIAppBuilder> {
  /// Current initialization status, starts with loading state
  DigiaUIStatus _status = const DigiaUIStatus.loading();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// Asynchronously initializes the Digia UI system and updates the status
  void _initialize() async {
    try {
      // Attempt to create and initialize DigiaUI with provided options
      final digiaUI = await DigiaUI.createWith(widget.options);

      // Only update state if the widget is still mounted to avoid memory leaks
      if (mounted) {
        setState(() {
          _status = DigiaUIStatus.ready(digiaUI);
        });
      }
    } catch (error, stackTrace) {
      // Handle initialization errors and update status accordingly
      if (mounted) {
        setState(() {
          _status = DigiaUIStatus.error(error, stackTrace);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If not ready, let the builder handle loading/error states
    if (!_status.isReady) {
      return widget.builder(context, _status);
    }

    // When ready, wrap with DigiaUIApp and pass through all configuration
    return DigiaUIApp(
      digiaUI: _status.digiaUI!,
      messageBus: widget.messageBus,
      analytics: widget.analytics,
      pageConfigProvider: widget.pageConfigProvider,
      icons: widget.icons,
      images: widget.images,
      fontFactory: widget.fontFactory,
      builder: (context) => widget.builder(context, _status),
    );
  }
}

/// Enumeration representing the different states of Digia UI initialization.
enum DigiaUIState {
  /// Initialization is in progress
  loading,

  /// Initialization completed successfully and system is ready to use
  ready,

  /// Initialization failed with an error
  error
}

/// Represents the current status of Digia UI initialization process.
///
/// This class encapsulates the current state along with relevant data
/// such as the initialized DigiaUI instance (when ready) or error
/// information (when failed).
class DigiaUIStatus {
  /// The current state of initialization
  final DigiaUIState state;

  /// The initialized DigiaUI instance (only available when state is ready)
  final DigiaUI? digiaUI;

  /// Error that occurred during initialization (only available when state is error)
  final Object? error;

  /// Stack trace associated with the error (only available when state is error)
  final StackTrace? stackTrace;

  /// Private constructor for creating status instances
  const DigiaUIStatus._({
    required this.state,
    this.digiaUI,
    this.error,
    this.stackTrace,
  });

  /// Creates a loading status indicating initialization is in progress
  const DigiaUIStatus.loading() : this._(state: DigiaUIState.loading);

  /// Creates a ready status with the initialized DigiaUI instance
  const DigiaUIStatus.ready(DigiaUI digiaUI)
      : this._(state: DigiaUIState.ready, digiaUI: digiaUI);

  /// Creates an error status with error details and optional stack trace
  const DigiaUIStatus.error(Object error, [StackTrace? stackTrace])
      : this._(state: DigiaUIState.error, error: error, stackTrace: stackTrace);

  /// Returns true if initialization is currently in progress
  bool get isLoading => state == DigiaUIState.loading;

  /// Returns true if initialization completed successfully
  bool get isReady => state == DigiaUIState.ready;

  /// Returns true if initialization failed with an error
  bool get hasError => state == DigiaUIState.error;
}
