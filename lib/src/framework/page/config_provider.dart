import '../../config/model.dart';
import '../../network/api_request/api_request.dart';
import '../models/component_definition.dart';
import '../models/page_definition.dart';
import '../utils/functional_util.dart';
import '../utils/object_util.dart';
import '../utils/types.dart';

/// Abstract interface for providing configuration data to the Digia UI system.
///
/// [ConfigProvider] defines the contract for accessing page definitions,
/// component definitions, API models, and routing information. This abstraction
/// allows for different configuration sources and enables testing with mock
/// implementations.
///
/// The provider is responsible for:
/// - **Page Management**: Retrieving page definitions and determining initial routes
/// - **Component Access**: Providing component definitions for reusable UI blocks
/// - **API Configuration**: Supplying API model configurations for network requests
/// - **Type Resolution**: Determining whether an ID represents a page or component
///
/// Implementations should handle:
/// - Configuration loading and caching
/// - Error handling for missing definitions
/// - Type validation and conversion
/// - Performance optimization for frequent lookups
abstract class ConfigProvider {
  /// Gets the initial route/page ID that should be displayed when the app starts.
  ///
  /// Returns the page identifier that serves as the entry point for the application.
  /// This is typically configured in the app settings within Digia Studio.
  String getInitialRoute();

  /// Retrieves a page definition by its unique identifier.
  ///
  /// Parameters:
  /// - [pageId]: The unique identifier of the page to retrieve
  ///
  /// Returns a [DUIPageDefinition] containing the page structure, state definitions,
  /// argument definitions, and UI hierarchy.
  ///
  /// Throws an exception if the page with the given ID is not found.
  DUIPageDefinition getPageDefinition(String pageId);

  /// Retrieves a component definition by its unique identifier.
  ///
  /// Parameters:
  /// - [componentId]: The unique identifier of the component to retrieve
  ///
  /// Returns a [DUIComponentDefinition] containing the component structure,
  /// argument definitions, state definitions, and UI hierarchy.
  ///
  /// Throws an exception if the component with the given ID is not found.
  DUIComponentDefinition getComponentDefinition(String componentId);

  /// Gets all API model configurations available in the project.
  ///
  /// Returns a map where keys are API model identifiers and values are
  /// [APIModel] instances containing endpoint configurations, authentication
  /// settings, and request/response specifications.
  Map<String, APIModel> getAllApiModels();

  /// Determines whether the given identifier represents a page.
  ///
  /// Parameters:
  /// - [id]: The identifier to check
  ///
  /// Returns true if the ID corresponds to a page definition, false if it
  /// represents a component or doesn't exist.
  bool isPage(String id);
}

/// Default implementation of [ConfigProvider] that uses [DUIConfig] as the data source.
///
/// [DUIConfigProvider] reads configuration data from a [DUIConfig] instance,
/// which typically contains the complete project configuration loaded from
/// the Digia Studio backend. This is the standard implementation used in
/// production applications.
///
/// The provider handles:
/// - **JSON Parsing**: Converts raw configuration data to typed objects
/// - **Error Handling**: Provides clear error messages for missing definitions
/// - **Type Safety**: Ensures proper type conversion and validation
/// - **Performance**: Efficient lookups and minimal data transformation
///
/// Example usage:
/// ```dart
/// final config = DUIConfig(configurationData);
/// final provider = DUIConfigProvider(config);
///
/// final initialPage = provider.getInitialRoute();
/// final pageDefinition = provider.getPageDefinition('home_page');
/// final apiModels = provider.getAllApiModels();
/// ```
class DUIConfigProvider implements ConfigProvider {
  /// The configuration instance containing all project data
  final DUIConfig config;

  /// Creates a new [DUIConfigProvider] with the specified configuration.
  ///
  /// Parameters:
  /// - [config]: The [DUIConfig] instance containing project configuration data
  const DUIConfigProvider(this.config);

  @override
  DUIPageDefinition getPageDefinition(String pageId) {
    // Extract page configuration from DUIConfig
    final pageDef = config.pages[pageId]?.as$<JsonLike>();

    if (pageDef == null) {
      throw 'Page definition for $pageId not found';
    }

    return DUIPageDefinition.fromJson(pageDef);
  }

  @override
  DUIComponentDefinition getComponentDefinition(String componentId) {
    // Extract component configuration from DUIConfig
    final componentDef = config.components?[componentId]?.as$<JsonLike>();

    if (componentDef == null) {
      throw 'Component definition for $componentId not found';
    }

    return DUIComponentDefinition.fromJson(componentDef);
  }

  @override
  String getInitialRoute() => config.initialRoute;

  @override
  Map<String, APIModel> getAllApiModels() {
    // Extract and parse all API model configurations
    return as$<JsonLike>(config.restConfig['resources'])?.map((k, v) {
          return MapEntry(k, APIModel.fromJson(as<JsonLike>(v)));
        }) ??
        {};
  }

  @override
  bool isPage(String id) => (config.pages[id] != null);
}
