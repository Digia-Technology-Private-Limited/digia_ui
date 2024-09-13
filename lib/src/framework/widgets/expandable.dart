import 'package:flutter/widgets.dart';
import '../core/extensions.dart';
import '../core/virtual_stateless_widget.dart';
import '../internal_widgets/internal_expandable.dart';
import '../render_payload.dart';

class VWExpandable extends VirtualStatelessWidget {
  VWExpandable({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    required super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    final header = childOf('header');
    final collapsed = childOf('collapsed');
    final expanded = childOf('expanded');
    if (header == null || collapsed == null || expanded == null) return empty();

    return InternalExpandable(
      header: header.toWidget(payload),
      collapsed: collapsed.toWidget(payload),
      expanded: expanded.toWidget(payload),
      props: props,
      payload: payload,
    );
  }
}
