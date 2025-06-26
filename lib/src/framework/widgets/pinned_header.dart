import 'package:flutter/widgets.dart';

import '../base/virtual_sliver.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWPinnedHeader extends VirtualSliver<Props> {
  VWPinnedHeader({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
  });

  @override
  Widget render(RenderPayload payload) {
    return PinnedHeaderSliver(
      child: child?.toWidget(payload),
    );
  }
}
