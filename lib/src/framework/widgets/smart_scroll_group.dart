import 'package:flutter/widgets.dart';

import '../base/virtual_sliver.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/sliver_util.dart';

class VWSmartScrollGroup extends VirtualSliver<Props> {
  VWSmartScrollGroup({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
  });

  @override
  Widget render(RenderPayload payload) {
    final slivers = childGroups?['slivers'];
    if (slivers == null || slivers.isEmpty) return empty();

    return SliverMainAxisGroup(
      slivers: [
        ...slivers
            .map((e) => SliverUtil.convertToSliver(e))
            .map((child) => child.toWidget(payload))
      ],
    );
  }
}
