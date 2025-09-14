import 'package:flutter/widgets.dart';
import 'package:digia_inspector_core/digia_inspector_core.dart';

import '../models/props.dart';
import '../render_payload.dart';

abstract class VirtualWidget {
  final String? refName;
  final WeakReference<VirtualWidget>? _parent;
  Props? parentProps;

  VirtualWidget? get parent => _parent?.target;

  VirtualWidget({
    required this.refName,
    required VirtualWidget? parent,
    this.parentProps,
  }) : _parent = parent != null ? WeakReference(parent) : null;

  Widget render(RenderPayload payload);

  Widget empty() => const SizedBox.shrink();

  Widget toWidget(RenderPayload payload) => render(payload);

  /// Creates a child context with this widget added to the hierarchy
  ObservabilityContext? buildHierarchyContext(RenderPayload payload) {
    if (payload.observabilityContext == null) return null;

    // Use refName if available, otherwise fall back to class name
    final widgetName = refName ?? runtimeType.toString();

    return payload.observabilityContext!.copyWith(
      widgetHierarchy: [
        ...payload.observabilityContext!.widgetHierarchy,
        widgetName
      ],
    );
  }
}
