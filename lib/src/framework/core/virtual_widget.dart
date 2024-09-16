import 'package:flutter/widgets.dart';

import '../render_payload.dart';
import '../virtual_widget_registry.dart';

abstract class VirtualWidget {
  final String? refName;
  final WeakReference<VirtualWidget>? _parent;

  VirtualWidgetRegistry registry;

  VirtualWidget? get parent => _parent?.target;

  VirtualWidget({
    required this.refName,
    required VirtualWidget? parent,
    VirtualWidgetRegistry? widgetFactory,
  })  : registry = VirtualWidgetRegistry.instance,
        _parent = parent != null ? WeakReference(parent) : null;

  Widget render(RenderPayload payload);

  Widget empty() => const SizedBox.shrink();

  Widget toWidget(RenderPayload payload) => render(payload);
}
