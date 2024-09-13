import 'package:flutter/widgets.dart';

import '../render_payload.dart';
import 'virtual_widget.dart';

extension ToWidget on VirtualWidget {
  Widget toWidget(RenderPayload payload) => render(payload);
}

extension ToWidgetArray on List<VirtualWidget> {
  List<Widget> toWidgetArray(RenderPayload payload) =>
      map((child) => child.toWidget(payload)).toList();
}
