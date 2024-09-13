import 'package:flutter/widgets.dart';

import 'base_virtual_widget.dart';
import 'models/vw_repeat_data.dart';
import 'render_payload.dart';

abstract class StatelessVirtualWidget extends VirtualWidget {
  Map<String, dynamic> props;
  Map<String, dynamic>? commonProps;
  Map<String, List<VirtualWidget>>? childGroups;
  VWRepeatData? repeatData;

  StatelessVirtualWidget(
    this.props, {
    this.commonProps,
    super.parent,
    super.refName,
    this.childGroups,
    this.repeatData,
  });

  VirtualWidget? get child => childOf('child');
  List<VirtualWidget>? get children => childrenOf('children');

  VirtualWidget? childOf(String key) {
    return childGroups?[key]?.firstOrNull;
  }

  List<VirtualWidget>? childrenOf(String key) {
    return childGroups?[key];
  }
}

extension ToWidget on VirtualWidget {
  Widget toWidget(RenderPayload payload) => render(payload);
}

extension ToWidgetArray on List<VirtualWidget> {
  List<Widget> toWidgetArray(RenderPayload payload) =>
      map((child) => child.toWidget(payload)).toList();
}
