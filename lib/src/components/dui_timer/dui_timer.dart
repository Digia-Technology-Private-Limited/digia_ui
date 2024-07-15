import 'dart:async';

import 'package:flutter/material.dart';

import '../../Utils/dui_widget_registry.dart';
import '../../core/action/action_handler.dart';
import '../../core/action/action_prop.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../../core/evaluator.dart';
import '../../core/page/props/dui_widget_json_data.dart';
import '../dui_base_stateful_widget.dart';

class DUITimer extends BaseStatefulWidget {
  final Map<String, dynamic> props;
  final DUIWidgetJsonData? child;

  const DUITimer({
    super.key,
    required super.varName,
    required this.props,
    this.child,
  });

  @override
  State<DUITimer> createState() => _DUITimerState();
}

class _DUITimerState extends DUIWidgetState<DUITimer> {
  int duration = 60;
  Duration updateInterval = const Duration(seconds: 1);
  String timerType = 'countDown';
  ActionFlow? onTimerEnd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    duration = eval<int>(widget.props['duration'], context: context) ?? 60;
    updateInterval = Duration(
        seconds:
            eval<int>(widget.props['updateInterval'], context: context) ?? 1);
    timerType = eval<String>(widget.props['timerType'], context: context) ??
        'countDown';
    onTimerEnd = ActionFlow.fromJson(widget.props['onTimerEnd']);
  }

  bool get isCountDown => timerType == 'countDown';

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder(
        initialData: isCountDown ? duration : 0,
        stream: Stream.periodic(
            updateInterval, (i) => isCountDown ? duration - i : i).takeWhile(
          (i) => isCountDown ? i >= 0 : i <= duration,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Future.delayed(const Duration(seconds: 0), () async {
              await ActionHandler.instance.execute(
                  context: context,
                  actionFlow: onTimerEnd ?? ActionFlow(actions: []));
            });
          }

          if (snapshot.hasData) {
            return BracketScope(
              variables: [('tickValue', snapshot.data)],
              builder: DUIJsonWidgetBuilder(
                  data: widget.child!, registry: DUIWidgetRegistry.shared),
            );
          }

          return const SizedBox.shrink();
        });
  }

  @override
  Map<String, Function> getVariables() {
    return {};
  }
}
