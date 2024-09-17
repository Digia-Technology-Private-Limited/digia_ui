import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../../core/action/action_handler.dart';
import '../../core/action/action_prop.dart';
import '../core/virtual_stateless_widget.dart';
import '../render_payload.dart';

const String _countDownTimerTypeValue = 'countDown';

class VWTimer extends VirtualStatelessWidget {
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

    final timerType = payload.eval<String>(props.get('timerType')) ??
        _countDownTimerTypeValue;

    final duration = payload.eval<int>(props.get('duration')) ?? 60;

    final updateIntervalInSeconds = Duration(
      seconds: payload.eval<int>(props.get('updateInterval')) ?? 1,
    );

    final initialValue = payload.eval<int>(props.get('initialValue')) ?? 0;

    bool isCountDown = timerType == _countDownTimerTypeValue;

    return StreamBuilder(
      initialData: isCountDown ? duration : initialValue,
      stream: Stream.periodic(
        updateIntervalInSeconds,
        (i) => isCountDown ? duration - i : initialValue + i,
      ).takeWhile(
        (i) => isCountDown ? duration - i >= 0 : initialValue + i <= duration,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) return empty();

        if (snapshot.connectionState == ConnectionState.done) {
          final timerEndAction = ActionFlow.fromJson(props.get('onTimerEnd'));
          Future.delayed(Duration.zero, () async {
            await ActionHandler.instance
                .execute(context: context, actionFlow: timerEndAction);
          });
        }

        if (snapshot.hasData) {
          final onTickAction = ActionFlow.fromJson(props.get('onTick'));
          Future.delayed(Duration.zero, () async {
            await ActionHandler.instance
                .execute(context: context, actionFlow: onTickAction);
          });
          return child!.toWidget(payload
              .copyWithChainedContext(_createExprContext(snapshot.data!)));
        }

        return empty();
      },
    );
  }

  ExprContext _createExprContext(int? value) {
    return ExprContext(variables: {
      'tickValue': value,
    });
  }
}
