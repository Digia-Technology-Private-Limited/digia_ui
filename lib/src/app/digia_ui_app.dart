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

class DigiaUIApp extends StatefulWidget {
  final DigiaUI digiaUI;
  final DUIAnalytics? analytics;
  final MessageBus? messageBus;
  final ConfigProvider? pageConfigProvider;
  final Map<String, IconData>? icons;
  final Map<String, ImageProvider<Object>>? images;
  final DUIFontFactory? fontFactory;
  final Widget Function(BuildContext context) builder;

  const DigiaUIApp({
    super.key,
    required this.digiaUI,
    this.messageBus,
    this.analytics,
    this.pageConfigProvider,
    this.icons,
    this.images,
    this.fontFactory,
    required this.builder,
  });

  @override
  State<DigiaUIApp> createState() => _DigiaUIAppState();
}

class _DigiaUIAppState extends State<DigiaUIApp> {
  @override
  void initState() {
    DigiaUIManager().initialize(widget.digiaUI);
    DUIAppState().init(widget.digiaUI.dslConfig.appState ?? []);
    DUIFactory().initialize(
      pageConfigProvider: widget.pageConfigProvider,
      icons: widget.icons,
      images: widget.images,
      fontFactory: widget.fontFactory,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DigiaUIScope(
      analyticsHandler: widget.analytics,
      messageBus: widget.messageBus,
      child: widget.builder(context),
    );
  }

  @override
  void dispose() {
    DigiaUIManager().destroy();
    DUIAppState().dispose();
    DUIFactory().destroy();
    super.dispose();
  }
}
