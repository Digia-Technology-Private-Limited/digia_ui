import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';
import '../../core/action/action_handler.dart';
import '../../core/action/action_prop.dart';
import '../core/extensions.dart';
import '../core/virtual_widget.dart';
import '../render_payload.dart';

class InternalTimer extends StatefulWidget {
  final Map<String, dynamic> props;
  final RenderPayload payload;
  final VirtualWidget? child;

  const InternalTimer({
    super.key,
    required this.props,
    required this.payload,
    required this.child,
  });

  @override
  State<InternalTimer> createState() => _InternalTimerState();
}

class _InternalTimerState extends State<InternalTimer> {
  int duration = 60;
  Duration updateInterval = const Duration(seconds: 1);
  String timerType = 'countDown';
  ActionFlow? onTimerEnd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    duration = widget.payload.eval<int>(widget.props['duration']) ?? 60;
    updateInterval = Duration(
      seconds: widget.payload.eval<int>(widget.props['updateInterval']) ?? 1,
    );
    timerType =
        widget.payload.eval<String>(widget.props['timerType']) ?? 'countDown';
    onTimerEnd = ActionFlow.fromJson(widget.props['onTimerEnd']);
  }

  bool get isCountDown => timerType == 'countDown';

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return const SizedBox.shrink();

    return StreamBuilder(
      initialData: isCountDown ? duration : 0,
      stream: Stream.periodic(
        updateInterval,
        (i) => isCountDown ? duration - i : i,
      ).takeWhile(
        (i) => isCountDown ? i >= 0 : i <= duration,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Future.delayed(Duration.zero, () async {
            await ActionHandler.instance.execute(
                context: context,
                actionFlow: onTimerEnd ?? ActionFlow(actions: []));
          });
        }

        if (snapshot.hasData) {
          // TODO: Add Action: onTickValue
          return widget.child!.toWidget(
            widget.payload.copyWithChainedContext(
              _createExprContext(snapshot.data),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  ExprContext _createExprContext(int? value) {
    return ExprContext(variables: {
      'tickValue': value,
    });
  }
}
