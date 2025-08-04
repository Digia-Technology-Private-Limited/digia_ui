import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/timer/widget.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import '../widget_props/timer_props.dart';

class VWTimer extends VirtualStatelessWidget<TimerProps> {
  VWTimer({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    final duration = payload.evalExpr(props.duration) ?? 0;
    final initialValue = payload.evalExpr(props.initialValue) ??
        (props.isCountDown ? duration : 0);

    final controller = payload.evalExpr(props.controller);

    if (duration < 0) {
      return child!.toWidget(
        payload.copyWithChainedContext(
          _createExprContext(initialValue),
        ),
      );
    }

    return TimerWidget(
      controller: controller,
      initialValue: initialValue,
      updateInterval: Duration(
        seconds: payload.evalExpr(props.updateInterval) ?? 1,
      ),
      duration: duration,
      isCountDown: props.isCountDown,
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
    final timerObj = {
      'tickValue': value,
    };

    return DefaultScopeContext(
      variables: {
        ...timerObj,
        ...?refName.maybe((it) => {it: timerObj}),
      },
    );
  }
}
