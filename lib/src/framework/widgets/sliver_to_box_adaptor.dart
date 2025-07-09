import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWSliverToBoxAdaptor extends VirtualStatelessWidget<Props> {
  VWSliverToBoxAdaptor(VirtualWidget child)
      : super(
          props: Props.empty(),
          commonProps: null,
          parentProps: null,
          parent: null,
          refName: null,
          childGroups: {
            'child': [child]
          },
        );

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return SliverToBoxAdapter(child: empty());

    return SliverToBoxAdapter(child: child!.toWidget(payload));
  }
}
