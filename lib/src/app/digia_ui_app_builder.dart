import 'package:flutter/widgets.dart';

import '../analytics/dui_analytics.dart';
import '../framework/font_factory.dart';
import '../framework/message_bus.dart';
import '../framework/page/config_provider.dart';
import '../init/config.dart';
import '../init/digia_ui.dart';
import 'digia_ui_app.dart';

class DigiaUIAppBuilder extends StatefulWidget {
  final InitConfig options;
  final Widget Function(BuildContext context, DigiaUIStatus status) builder;
  final DUIAnalytics? analytics;
  final MessageBus? messageBus;
  final ConfigProvider? pageConfigProvider;
  final Map<String, IconData>? icons;
  final Map<String, ImageProvider<Object>>? images;
  final DUIFontFactory? fontFactory;

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
  DigiaUIStatus _status = const DigiaUIStatus.loading();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    try {
      final digiaUI = await DigiaUI.createWith(widget.options);
      if (mounted) {
        setState(() {
          _status = DigiaUIStatus.ready(digiaUI);
        });
      }
    } catch (error, stackTrace) {
      if (mounted) {
        setState(() {
          _status = DigiaUIStatus.error(error, stackTrace);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.builder(context, _status);

    if (!_status.isReady) return child;

    return DigiaUIApp(
      digiaUI: _status.digiaUI!,
      messageBus: widget.messageBus,
      analytics: widget.analytics,
      pageConfigProvider: widget.pageConfigProvider,
      icons: widget.icons,
      images: widget.images,
      fontFactory: widget.fontFactory,
      child: child,
    );
  }
}

enum DigiaUIState { loading, ready, error }

class DigiaUIStatus {
  final DigiaUIState state;
  final DigiaUI? digiaUI;
  final Object? error;
  final StackTrace? stackTrace;

  const DigiaUIStatus._({
    required this.state,
    this.digiaUI,
    this.error,
    this.stackTrace,
  });

  const DigiaUIStatus.loading() : this._(state: DigiaUIState.loading);

  const DigiaUIStatus.ready(DigiaUI digiaUI)
      : this._(state: DigiaUIState.ready, digiaUI: digiaUI);

  const DigiaUIStatus.error(Object error, [StackTrace? stackTrace])
      : this._(state: DigiaUIState.error, error: error, stackTrace: stackTrace);

  bool get isLoading => state == DigiaUIState.loading;
  bool get isReady => state == DigiaUIState.ready;
  bool get hasError => state == DigiaUIState.error;
}
