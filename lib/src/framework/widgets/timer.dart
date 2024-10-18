import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../data_type/compex_object.dart';
import '../data_type/data_type.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/timer/controller.dart';
import '../internal_widgets/timer/widget.dart';
import '../render_payload.dart';
import '../widget_props/timer_props.dart';

class VWTimer extends VirtualStatelessWidget<TimerProps> {
  VWTimer({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    final dataType = DataTypeFetch.dataType<TimerController>(
        props.dataType, payload, DataType.timerController);

    if (dataType == null) return empty();

    return TimerWidget(
      controller: dataType,
      builder: (innerCtx, snapshot) {
        final updatedPayload = payload.copyWithChainedContext(
          _createExprContext(snapshot.data),
          buildContext: innerCtx,
        );

        // This should never happen
        if (snapshot.hasError) {
          return empty();
        }

        if (snapshot.connectionState != ConnectionState.none &&
            snapshot.connectionState != ConnectionState.waiting) {
          Future.delayed(
            Duration.zero,
            () async => await updatedPayload.executeAction(props.onTick),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // Timer has ended
          Future.delayed(Duration.zero, () async {
            Future.delayed(
              Duration.zero,
              () async => await updatedPayload.executeAction(props.onTimerEnd),
            );
          });
        }

        return child!.toWidget(updatedPayload);
      },
    );
  }

  ScopeContext _createExprContext(int? value) {
    return DefaultScopeContext(variables: {
      'tickValue': value,
    });
  }
}
