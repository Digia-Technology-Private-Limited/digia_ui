import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
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

    final duration = props.duration?.evaluate(payload.exprContext) ?? 0;
    final initialValue = props.initialValue?.evaluate(payload.exprContext) ?? 0;

    if (duration <= 0) {
      return child!.toWidget(
        payload.copyWithChainedContext(
          _createExprContext(initialValue),
        ),
      );
    }

    final updateInterval = Duration(
      seconds: props.updateInterval?.evaluate(payload.exprContext) ?? 1,
    );

    return StreamBuilder(
      initialData: initialValue,
      stream: Stream<int>.periodic(
        updateInterval,
        (i) =>
            props.isCountDown ? initialValue - (i + 1) : initialValue + (i + 1),
      ).take(duration),
      builder: (context, snapshot) {
        // This should never happen
        if (snapshot.hasError) {
          return empty();
        }

        if (snapshot.connectionState != ConnectionState.none &&
            snapshot.connectionState != ConnectionState.waiting) {
          Future.delayed(
            Duration.zero,
            () async => await payload.executeAction(props.onTick),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // Timer has ended
          Future.delayed(Duration.zero, () async {
            Future.delayed(
              Duration.zero,
              () async => await payload.executeAction(props.onTimerEnd),
            );
          });
        }

        return child!.toWidget(
          payload.copyWithChainedContext(
            _createExprContext(snapshot.data!),
          ),
        );
      },
    );
  }

  ExprContext _createExprContext(int? value) {
    return ExprContext(variables: {
      'tickValue': value,
    });
  }
}
