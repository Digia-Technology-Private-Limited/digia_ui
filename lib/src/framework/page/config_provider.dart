import '../../config_resolver.dart';
import '../../network/api_request/api_request.dart';
import '../models/page_definition.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

abstract class ConfigProvider {
  String getInitialRoute();
  DUIPageDefinition getPageDefinition(String pageId);
  JsonLike getComponentConfig(String componentId);
  Map<String, APIModel> getAllApiModels();
}

class DUIConfigProvider implements ConfigProvider {
  final DUIConfig config;

  const DUIConfigProvider(this.config);

  @override
  DUIPageDefinition getPageDefinition(String pageId) {
    // Extract page config from DUIConfig
    final pageDef = config.pages[pageId];

    if (pageDef == null) {
      throw 'Page definition for $pageId not found';
    }

    return DUIPageDefinition.fromJson(pageDef);
  }

  @override
  JsonLike getComponentConfig(String componentId) {
    // Extract page config from DUIConfig
    // return config.getPageData(pageUid);
    return {};
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
}
