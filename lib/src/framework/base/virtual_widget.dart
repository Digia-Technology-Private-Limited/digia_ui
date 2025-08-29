import 'package:flutter/widgets.dart';

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
}
