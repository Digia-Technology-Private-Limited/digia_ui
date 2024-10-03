import 'package:flutter/widgets.dart';

import '../base/virtual_widget.dart';
import '../render_payload.dart';
import '../utils/types.dart';

class VirtualComponentWidget extends VirtualWidget {
  final String id;
  final JsonLike? args;
  final Widget Function(String id, JsonLike? args) componentBuilder;

  VirtualComponentWidget({
    required this.id,
    required this.args,
    required this.componentBuilder,
    super.refName,
  }) : super(parent: null);

  @override
  Widget render(RenderPayload payload) => componentBuilder(id, args);
}
