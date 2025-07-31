import 'package:flutter/widgets.dart';

import '../analytics/dui_analytics.dart';
import '../config/app_state/global_state.dart';
import '../framework/digia_ui_scope.dart';
import '../framework/message_bus.dart';
import '../init/digia_ui.dart';
import '../init/digia_ui_manager.dart';

class DigiaUIApp extends StatefulWidget {
  final DigiaUI digiaUI;
  final Widget child;
  final DUIAnalytics? analytics;
  final MessageBus? messageBus;

  const DigiaUIApp({
    super.key,
    required this.digiaUI,
    required this.child,
    this.messageBus,
    this.analytics,
  });

  @override
  State<DigiaUIApp> createState() => _DigiaUIAppState();
}

class _DigiaUIAppState extends State<DigiaUIApp> {
  @override
  void initState() {
    DigiaUIManager().initialize(widget.digiaUI);
    DUIAppState().init(widget.digiaUI.dslConfig.appState ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DigiaUIScope(
      analyticsHandler: widget.analytics,
      messageBus: widget.messageBus,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    DigiaUIManager().destroy();
    DUIAppState().dispose();
    super.dispose();
  }
}
