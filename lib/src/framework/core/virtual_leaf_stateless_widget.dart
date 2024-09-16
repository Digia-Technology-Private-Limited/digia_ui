import 'package:flutter/widgets.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../components/dui_widget_creator_fn.dart';
import '../../components/utils/DUIStyleClass/dui_style_class.dart';
import '../../core/action/action_prop.dart';
import '../models/props.dart';
import '../render_payload.dart';

import 'virtual_widget.dart';

abstract class VirtualLeafStatelessWidget extends VirtualWidget {
  Props props;
  Props? commonProps;

  VirtualLeafStatelessWidget({
    required this.props,
    required this.commonProps,
    required super.parent,
    required super.refName,
  });

  @override
  Widget toWidget(RenderPayload payload) {
    if (commonProps == null || commonProps!.isEmpty) return render(payload);

    final isVisible =
        payload.eval<bool>(commonProps?.get('visibility')) ?? true;
    if (!isVisible) return empty();

    var current = render(payload);

    // Styling
    final styleClass = DUIStyleClass.fromJson(commonProps?.get('style'));

    current = wrapInContainer(
      context: payload.buildContext,
      styleClass: styleClass,
      child: current,
    );

    // Align
    current = DUIAlign(
      alignment: commonProps?.get('align'),
      child: current,
    );

    final onTapProp = ifNotNull(
      commonProps?.getMap('onClick'),
      ActionFlow.fromJson,
    );

    current = DUIGestureDetector(
      context: payload.buildContext,
      actionFlow: onTapProp,
      child: current,
      borderRadius: DUIDecoder.toBorderRadius(styleClass?.border?.borderRadius),
    );

    return current;
  }
}
