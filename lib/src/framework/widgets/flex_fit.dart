import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWFlexFit extends VirtualStatelessWidget<Props> {
  VWFlexFit({
    required super.props,
    required super.parent,
    super.refName,
    required super.childGroups,
  }) : super(
          commonProps: null,
          repeatData: null,
        );

  VWFlexFit.fromValues({
    required String? flexFitType,
    int flexValue = 1,
    required VirtualWidget child,
    required VirtualWidget? parent,
  }) : this(
          props: Props({
            'flexFitType': flexFitType,
            'flexValue': flexValue,
          }),
          parent: parent,
          childGroups: {
            'child': [child]
          },
        );

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    final flexFitType = props.getString('flexFitType');
    final flexValue = props.getInt('flexValue');
    final childWidget = child!.toWidget(payload);

    if (flexFitType == 'tight') {
      return Expanded(
        flex: flexValue ?? 1,
        child: childWidget,
      );
    }

    if (flexFitType == 'loose') {
      return Flexible(
        flex: flexValue ?? 1,
        child: childWidget,
      );
    }

    return childWidget;
  }
}
