import '../core/functions/js_functions.dart';
import '../framework/data_type/variable.dart';
import '../framework/data_type/variable_json_converter.dart';
import '../framework/utils/functional_util.dart';
import '../network/api_request/api_request.dart';

/// Core configuration model for the Digia UI system.
///
/// [DUIConfig] represents the complete configuration loaded from the Digia Studio
/// backend, containing all the information needed to render pages, components,
/// and handle API interactions. This includes theme configuration, page definitions,
/// component definitions, API configurations, and environment settings.
///
/// The configuration is typically loaded during app initialization and used
/// throughout the application lifecycle to:
/// - Define UI structure and styling
/// - Configure API endpoints and authentication
/// - Manage environment variables and app state
/// - Handle routing and navigation
///
/// Key components:
/// - **Theme Configuration**: Colors, fonts, and styling tokens
/// - **Pages & Components**: UI definitions and structure
/// - **REST Configuration**: API endpoints and models
/// - **Environment Settings**: Variables and configuration per environment
/// - **App State**: Global state definitions and initial values
///
/// Example usage:
/// ```dart
/// final config = DUIConfig(configData);
/// final primaryColor = config.getColorValue('primary');
/// final apiModel = config.getApiDataSource('userApi');
/// config.setEnvVariable('baseUrl', 'https://api.example.com');
/// ```
class DUIConfig {
  /// Theme configuration including colors and fonts
  final Map<String, dynamic> _themeConfig;

  /// Map of all page definitions indexed by page ID
  final Map<String, Object?> pages;

  /// Map of all component definitions indexed by component ID (optional)
  final Map<String, Object?>? components;

  /// REST API configuration including endpoints and models
  final Map<String, dynamic> restConfig;

  /// The initial route/page ID to display when the app starts
  final String initialRoute;

  /// Path to custom JavaScript functions file (optional)
  final String? functionsFilePath;

  /// Global app state definitions and initial values (optional)
  final List? appState;

  /// Flag indicating if the configuration version was updated (optional)
  final bool? versionUpdated;

  /// Configuration version number (optional)
  final int? version;

  /// Environment-specific variables and settings (optional)
  final Map<String, dynamic>? _environment;

  /// JavaScript functions instance for custom logic (optional)
  JSFunctions? jsFunctions;

  final List<dynamic>? assetImages;

  /// Creates a new [DUIConfig] instance from the provided configuration data.
  ///
  /// The [data] parameter should be a Map containing the complete configuration
  /// structure as received from the Digia Studio backend. This constructor
  /// parses and extracts all necessary configuration sections.
  ///
  /// Required fields in data:
  /// - `theme`: Theme configuration with colors and fonts
  /// - `pages`: Page definitions
  /// - `rest`: API configuration
  /// - `appSettings.initialRoute`: Starting page ID
  ///
  /// Optional fields:
  /// - `components`: Component definitions
  /// - `appState`: Global state definitions
  /// - `version`: Configuration version
  /// - `versionUpdated`: Version update flag
  /// - `functionsFilePath`: Custom functions file path
  /// - `environment`: Environment variables
  DUIConfig(dynamic data)
      : _themeConfig = as<Map<String, dynamic>>(data['theme']),
        pages = as<Map<String, Object?>>(data['pages']),
        components = as$<Map<String, Object?>>(data['components']),
        restConfig = as<Map<String, dynamic>>(data['rest']),
        initialRoute = as<String>(data['appSettings']['initialRoute']),
        appState = as$<List>(data['appState']),
        version = as$<int>(data['version']),
        versionUpdated = as$<bool>(data['versionUpdated']),
        functionsFilePath = as$<String>(data['functionsFilePath']),
        _environment = as$<Map<String, dynamic>>(data['environment']),
        assetImages = as$<List>(data['appAssets']);

  /// Internal getter for light theme colors
  Map<String, dynamic> get _colors =>
      as<Map<String, dynamic>>(_themeConfig['colors']['light']);

  /// Gets the light theme color tokens as a map of color names to values
  Map<String, Object?> get colorTokens =>
      as<Map<String, Object?>>(_themeConfig['colors']['light']);

  /// Gets the dark theme color tokens as a map of color names to values
  Map<String, Object?> get darkColorTokens =>
      as<Map<String, Object?>>(_themeConfig['colors']['dark']);

  /// Gets the font tokens as a map of font names to font configurations
  Map<String, Object?> get fontTokens =>
      as<Map<String, Object?>>(_themeConfig['fonts']);

  /// Sets an environment variable value at runtime.
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
  void setEnvVariable(String varName, Object? value) {
    final Map<String, Variable> variables = getEnvironmentVariables();
    if (!variables.containsKey(varName)) {
      return;
    }
    variables[varName] = variables[varName]!.copyWith(defaultValue: value);

    _environment?['variables'] =
        const VariableJsonConverter().toJson(variables);
  }

  /// Retrieves a color value by its token name.
  ///
  /// This method looks up a color value from the light theme colors
  /// using the provided token name. Returns null if the token doesn't exist.
  ///
  /// Parameters:
  /// - [colorToken]: The name/key of the color token to retrieve
  ///
  /// Returns the color value as a string (typically hex format) or null.
  ///
  /// Example:
  /// ```dart
  /// final primaryColor = config.getColorValue('primary');
  /// // Returns something like '#FF5722'
  /// ```
  String? getColorValue(String colorToken) {
    return as$<String>(_colors[colorToken]);
  }

  /// Gets the default HTTP headers for API requests.
  ///
  /// These headers are applied to all API requests made through the
  /// Digia UI system unless overridden by specific API configurations.
  ///
  /// Returns a map of header names to values, or null if no default
  /// headers are configured.
  ///
  /// Example:
  /// ```dart
  /// final headers = config.getDefaultHeaders();
  /// // Returns: {'Authorization': 'Bearer token', 'Content-Type': 'application/json'}
  /// ```
  Map<String, dynamic>? getDefaultHeaders() {
    return as$<Map<String, dynamic>>(restConfig['defaultHeaders']);
  }

  /// Gets all environment variables defined in the configuration.
  ///
  /// Environment variables are used to store configuration values that
  /// can vary between different environments (development, staging, production)
  /// or be modified at runtime.
  ///
  /// Returns a map of variable names to Variable objects containing
  /// type information, default values, and other metadata.
  ///
  /// Example:
  /// ```dart
  /// final envVars = config.getEnvironmentVariables();
  /// final baseUrlVar = envVars['baseUrl'];
  /// print(baseUrlVar?.defaultValue); // 'https://api.example.com'
  /// ```
  Map<String, Variable> getEnvironmentVariables() {
    return const VariableJsonConverter()
        .fromJson(as$<Map<String, dynamic>>(_environment?['variables']));
  }

  /// Retrieves an API model configuration by its identifier.
  ///
  /// API models define the structure and configuration for making HTTP
  /// requests to specific endpoints. This includes URL patterns, request
  /// methods, authentication requirements, and response parsing.
  ///
  /// Parameters:
  /// - [id]: The unique identifier of the API model to retrieve
  ///
  /// Returns an [APIModel] instance configured for the specified endpoint.
  ///
  /// Throws an exception if the API model with the given ID is not found.
  ///
  /// Example:
  /// ```dart
  /// final userApi = config.getApiDataSource('userApi');
  /// // Use the API model to make requests
  /// ```
  APIModel getApiDataSource(String id) {
    return APIModel.fromJson(
        as<Map<String, dynamic>>(restConfig['resources'][id]));
  }
}
