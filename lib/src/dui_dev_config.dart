import 'package:digia_inspector_core/digia_inspector_core.dart';

/// Sealed class representing different hosting environments for Digia UI.
///
/// [DigiaUIHost] defines the hosting configuration for the Digia UI system,
/// allowing different deployment scenarios and resource proxy configurations.
/// This abstraction enables support for various hosting environments while
/// maintaining consistent API access patterns.
///
/// The class supports resource proxy URLs for scenarios where assets need
/// to be served through a different endpoint than the main API.
sealed class DigiaUIHost {
  /// Optional URL for proxying resource requests (images, fonts, etc.)
  final String? resourceProxyUrl;

  /// Creates a new [DigiaUIHost] with optional resource proxy configuration.
  ///
  /// Parameters:
  /// - [resourceProxyUrl]: URL to proxy resource requests through
  const DigiaUIHost({this.resourceProxyUrl});
}

/// Host configuration for Digia Dashboard deployment.
///
/// [DashboardHost] represents the standard Digia Studio dashboard hosting
/// environment. This is the most common deployment scenario where the
/// application connects to the official Digia Studio backend services.
///
/// Example usage:
/// ```dart
/// const host = DashboardHost(
///   resourceProxyUrl: 'https://cdn.example.com', // Optional
/// );
/// ```
class DashboardHost extends DigiaUIHost {
  /// Creates a new [DashboardHost] configuration.
  ///
  /// This represents the standard Digia Studio dashboard hosting environment.
  /// Resource proxy URL can be provided to serve static assets through
  /// a different CDN or proxy service.
  const DashboardHost({super.resourceProxyUrl});
}

/// Developer configuration for debugging and development features.
///
/// [DeveloperConfig] provides configuration options specifically designed
/// for development and debugging scenarios. This includes proxy settings,
/// logging configuration, inspection tools, and custom backend URLs.
///
/// Key features:
/// - **Proxy Support**: Route traffic through debugging proxies
/// - **Inspection Tools**: Network request monitoring and debugging
/// - **Custom Logging**: Configurable logging for development insights
/// - **Backend Override**: Use custom backend URLs for testing
/// - **Host Configuration**: Custom hosting environment settings
///
/// The configuration is typically only used in debug builds and should
/// not be included in production releases for security and performance reasons.
///
/// Example usage:
/// ```dart
/// const developerConfig = DeveloperConfig(
///   proxyUrl: '192.168.1.100:8888', // Charles Proxy
///   logger: MyCustomLogger(),
///   baseUrl: 'https://dev-api.digia.tech/api/v1',
///   host: DashboardHost(),
/// );
/// ```
class DeveloperConfig {
  /// Proxy URL for routing HTTP traffic through debugging tools.
  ///
  /// This is typically used with tools like Charles Proxy, Fiddler, or
  /// other network debugging proxies. The URL should include the port
  /// number (e.g., '192.168.1.100:8888').
  ///
  /// Only applies to Android/iOS platforms in debug mode.
  final String? proxyUrl;

  /// Logger instance for capturing debug information and events.
  ///
  /// Custom loggers can be provided to integrate with existing logging
  /// infrastructure or to capture specific types of debug information.
  /// The logger receives events from throughout the Digia UI system.
  final DigiaLogger? logger;

  /// Host configuration for custom deployment environments.
  ///
  /// Allows overriding the default hosting configuration to connect to
  /// custom backend deployments or use different resource serving strategies.
  final DigiaUIHost? host;

  /// Base URL for Digia Studio backend API requests.
  ///
  /// This allows connecting to custom backend deployments such as:
  /// - Development/staging environments
  /// - Self-hosted Digia Studio instances
  /// - Local development servers
  ///
  /// Defaults to the production Digia Studio API URL.
  final String baseUrl;

  /// Creates a new [DeveloperConfig] with optional debugging and development features.
  ///
  /// All parameters are optional, allowing selective enablement of development
  /// features based on specific debugging needs.
  ///
  /// Parameters:
  /// - [proxyUrl]: HTTP proxy URL for network debugging
  /// - [logger]: Custom logger for debug information
  /// - [host]: Custom host configuration
  /// - [baseUrl]: Custom backend API URL (defaults to production)
  const DeveloperConfig({
    this.proxyUrl,
    this.logger,
    this.host,
    this.baseUrl = 'https://app.digia.tech/api/v1',
  });
}
