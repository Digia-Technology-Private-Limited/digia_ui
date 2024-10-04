import '../../config_resolver.dart';
import '../../network/api_request/api_request.dart';
import '../models/component_definition.dart';
import '../models/page_definition.dart';
import '../utils/functional_util.dart';
import '../utils/object_util.dart';
import '../utils/types.dart';

abstract class ConfigProvider {
  String getInitialRoute();
  DUIPageDefinition getPageDefinition(String pageId);
  DUIComponentDefinition getComponentDefinition(String componentId);
  Map<String, APIModel> getAllApiModels();
  bool isPage(String id);
}

class DUIConfigProvider implements ConfigProvider {
  final DUIConfig config;

  const DUIConfigProvider(this.config);

  @override
  DUIPageDefinition getPageDefinition(String pageId) {
    // Extract page config from DUIConfig
    final pageDef = config.pages[pageId]?.as$<JsonLike>();

    if (pageDef == null) {
      throw 'Page definition for $pageId not found';
    }

    return DUIPageDefinition.fromJson(pageDef);
  }

  @override
  DUIComponentDefinition getComponentDefinition(String componentId) {
    final componentDef = config.components?[componentId]?.as$<JsonLike>();

    if (componentDef == null) {
      throw 'Page definition for $componentId not found';
    }

    return DUIComponentDefinition.fromJson(componentDef);
  }

  @override
  String getInitialRoute() => config.initialRoute;

  @override
  Map<String, APIModel> getAllApiModels() {
    return as$<JsonLike>(config.restConfig['resources'])?.map((k, v) {
          return MapEntry(k, APIModel.fromJson(as<JsonLike>(v)));
        }) ??
        {};
  }

  @override
  bool isPage(String id) => (config.pages[id] != null);
}
