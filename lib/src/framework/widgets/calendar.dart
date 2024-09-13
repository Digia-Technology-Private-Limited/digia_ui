import 'package:flutter/widgets.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_calendar.dart';
import '../render_payload.dart';

class VWCalendar extends VirtualLeafStatelessWidget {
  VWCalendar({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    return InternalCalendar(
      props: props,
      payload: payload,
    );
  }
}
