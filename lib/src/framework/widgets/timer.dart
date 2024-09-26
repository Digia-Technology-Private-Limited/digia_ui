import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
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

    final duration = payload.evalExpr(props.duration) ?? 0;
    final initialValue = payload.evalExpr(props.initialValue) ?? 0;

    if (duration <= 0) {
      return child!.toWidget(
        payload.copyWithChainedContext(
          _createExprContext(initialValue),
        ),
      );
    }

    final controller = TimerController(
      duration: duration,
      initialValue: initialValue,
      updateInterval: Duration(
        seconds: payload.evalExpr(props.updateInterval) ?? 1,
      ),
      isCountDown: props.isCountDown,
    );

    return TimerWidget(
      controller: controller,
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

  ExprContext _createExprContext(int? value) {
    return ExprContext(variables: {
      'tickValue': value,
    });
  }
}
