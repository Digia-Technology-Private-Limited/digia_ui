import 'package:flutter/widgets.dart';

import '../render_payload.dart';

import 'virtual_widget.dart';

class VirtualBuilderWidget extends VirtualWidget {
  final Widget Function(RenderPayload payload) builder;

  VirtualBuilderWidget(
    this.builder, {
    super.refName,
  }) : super(parent: null);

  @override
  Widget render(RenderPayload payload) => builder(payload);
}
