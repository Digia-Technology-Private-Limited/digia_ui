import 'package:flutter/widgets.dart';

import '../render_payload.dart';
import '../virtual_widget_registry.dart';

abstract class VirtualWidget {
  String? refName;
  VirtualWidget? parent;

  VirtualWidgetRegistry registry;

  VirtualWidget({
    required this.refName,
    required this.parent,
    VirtualWidgetRegistry? widgetFactory,
  }) : registry = VirtualWidgetRegistry.instance;

  Widget render(RenderPayload payload);

  Widget empty() => const SizedBox.shrink();
}
