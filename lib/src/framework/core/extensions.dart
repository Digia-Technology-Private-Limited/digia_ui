import 'package:flutter/widgets.dart';

import '../render_payload.dart';
import 'virtual_widget.dart';

extension ToWidgetArray on Iterable<VirtualWidget> {
  List<Widget> toWidgetArray(RenderPayload payload) =>
      map((child) => child.toWidget(payload)).toList();
}
