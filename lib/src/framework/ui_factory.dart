import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../Utils/basic_shared_utils/color_decoder.dart';
import '../config_resolver.dart';
import '../digia_ui_client.dart';
import 'core/virtual_widget.dart';
import 'models/vw_node_data.dart';
import 'page/page.dart';
import 'utils/type_aliases.dart';
import 'virtual_widget_registry.dart';

abstract class ConfigProvider {
  DUIPageDefinition getPageDefinition(String pageUid);
  JsonLike getComponentConfig(String componentUid);
}

class DUIConfigProvider implements ConfigProvider {
  final DUIConfig config;

  const DUIConfigProvider(this.config);

  @override
  DUIPageDefinition getPageDefinition(String pageUid) {
    // Extract page config from DUIConfig
    final pageDef = config.pages[pageUid];

    if (pageDef == null) {
      throw 'Page definition for $pageUid not found';
    }

    return DUIPageDefinition.fromJson(pageDef);
  }

  @override
  JsonLike getComponentConfig(String pageUid) {
    // Extract page config from DUIConfig
    // return config.getPageData(pageUid);
    return {};
  }
}

class DUIFactory {
  static final DUIFactory _instance = DUIFactory._internal();

  factory DUIFactory() {
    return _instance;
  }

  late final ConfigProvider configProvider;
  late final UIResources resources;

  DUIFactory._internal();

  // Initialize the singleton with all necessary values
  void initialize({
    ConfigProvider? pageConfigProvider,
    Map<String, IconData>? icons,
    Map<String, ImageProvider>? images,
    Map<String, TextStyle>? textStyles,
  }) {
    configProvider =
        pageConfigProvider ?? DUIConfigProvider(DigiaUIClient.instance.config);
    resources = UIResources(
      icons: icons ?? {},
      images: images ?? {},
      textStyles: textStyles ?? {},
      colorTokens: DigiaUIClient.instance.config.colorTokens.map(
        (key, value) => MapEntry(
          key,
          ColorDecoder.fromString(value),
        ),
      ),
    );
  }

  // Register a new widget
  void registerWidget(
      String identifier,
      VirtualWidget Function(
        VWNodeData data,
        VirtualWidgetRegistry registry,
      ) virtualWidgetBuilder) {
    VirtualWidgetRegistry.instance
        .registerWidget(identifier, virtualWidgetBuilder);
  }

  // Create a page with optional overriding UI resources
  Widget createPage(
    String pageUid,
    JsonLike? pageArgs, {
    Map<String, IconData>? overrideIcons,
    Map<String, ImageProvider>? overrideImages,
    Map<String, TextStyle>? overrideTextStyles,
    Map<String, Color?>? overrideColorTokens,
  }) {
    // Merge overriding resources with existing resources
    final mergedResources = UIResources(
      icons: {...resources.icons, ...?overrideIcons},
      images: {...resources.images, ...?overrideImages},
      textStyles: {...resources.textStyles, ...?overrideTextStyles},
      colorTokens: {...resources.colorTokens, ...?overrideColorTokens},
    );

    return DUIPage(
      pageUid: pageUid,
      pageArgs: pageArgs,
      resources: mergedResources,
      pageDef: configProvider.getPageDefinition(pageUid),
      registry: VirtualWidgetRegistry.instance,
      scope: ExprContext(
        name: 'global',
        variables: {...DigiaUIClient.instance.jsVars},
      ),
    );
  }

  Widget createComponent(String componentUid) {
    return const SizedBox.shrink();
    // return DUIComponent(componentUid: componentUid);
  }
}

class UIResources {
  final Map<String, IconData> icons;
  final Map<String, ImageProvider> images;
  final Map<String, TextStyle> textStyles;
  final Map<String, Color?> colorTokens;

  UIResources({
    required this.icons,
    required this.images,
    required this.textStyles,
    required this.colorTokens,
  });
}
