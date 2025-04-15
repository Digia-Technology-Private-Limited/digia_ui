import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../render_payload.dart';
import '../widget_props/flex_fit_props.dart';

class VWFlexFit extends VirtualStatelessWidget<FlexFitProps> {
  VWFlexFit({
    required super.props,
    required super.parent,
    super.refName,
    required super.childGroups,
  }) : super(
          commonProps: null,
          repeatData: null,
        );

  VWFlexFit.withChild({
    required FlexFitProps props,
    required VirtualWidget child,
  }) : this(
          props: props,
          parent: null,
          childGroups: {
            'child': [child],
          },
        );

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    final flexFitType = props.flexFitType;
    final flexValue = props.flexValue ?? 1;
    final childWidget = child!.toWidget(payload);

    if (flexFitType == 'tight') {
      return Expanded(
        flex: flexValue,
        child: childWidget,
      );
    }

    if (flexFitType == 'loose') {
      return Flexible(
        flex: flexValue,
        child: childWidget,
      );
    }

    return childWidget;
  }
}
