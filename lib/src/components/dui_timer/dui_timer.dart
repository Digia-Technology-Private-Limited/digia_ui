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
  int startingPoint = 0;
  ActionFlow? onTimerEnd;
  ActionFlow? onTick;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    duration = eval<int>(widget.props['duration'], context: context) ?? 60;
    updateInterval = Duration(
        seconds:
            eval<int>(widget.props['updateInterval'], context: context) ?? 1);
    timerType = eval<String>(widget.props['timerType'], context: context) ??
        'countDown';
    startingPoint =
        eval<int>(widget.props['startingPoint'], context: context) ?? 0;
    onTimerEnd = ActionFlow.fromJson(widget.props['onTimerEnd']);
    onTick = ActionFlow.fromJson(widget.props['onTick']);
  }

  @override
  void didUpdateWidget(covariant DUITimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    duration = eval<int>(widget.props['duration'], context: context) ?? 60;
    updateInterval = Duration(
        seconds:
            eval<int>(widget.props['updateInterval'], context: context) ?? 1);
    timerType = eval<String>(widget.props['timerType'], context: context) ??
        'countDown';
    startingPoint =
        eval<int>(widget.props['startingPoint'], context: context) ?? 0;
    onTimerEnd = ActionFlow.fromJson(widget.props['onTimerEnd']);
    onTick = ActionFlow.fromJson(widget.props['onTick']);
  }

  bool get isCountDown => timerType == 'countDown';

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) {
      return const SizedBox.shrink();
    }

    // Handle case: duration is 0
    if (duration <= 0) {
      //TODO: @tushar @vivek used for PROBO football release. Remove when things moved to new system
      return BracketScope(
        variables: [
          ('tickValue', startingPoint),
          ...?BracketScope.maybeOf(context)?.variables
        ],
        builder: DUIJsonWidgetBuilder(
            data: widget.child!, registry: DUIWidgetRegistry.shared),
      );
    }

    return StreamBuilder<int>(
        initialData: startingPoint,
        stream: Stream.periodic(
          updateInterval,
          (i) =>
              isCountDown ? startingPoint - (i + 1) : startingPoint + (i + 1),
        ).take(duration),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          }

          if (snapshot.connectionState != ConnectionState.none &&
              snapshot.connectionState != ConnectionState.waiting) {
            Future.delayed(Duration.zero, () async {
              await ActionHandler.instance.execute(
                  context: context,
                  actionFlow: onTick ?? ActionFlow(actions: []));
            });
          }

          if (snapshot.connectionState == ConnectionState.done) {
            // Timer has ended
            Future.delayed(Duration.zero, () async {
              await ActionHandler.instance.execute(
                  context: context,
                  actionFlow: onTimerEnd ?? ActionFlow(actions: []));
            });
          }

          //TODO: @tushar @vivek used for PROBO football release. Remove when things moved to new system
          return BracketScope(
            variables: [
              ('tickValue', snapshot.data),
              ...?BracketScope.maybeOf(context)?.variables
            ],
            builder: DUIJsonWidgetBuilder(
                data: widget.child!, registry: DUIWidgetRegistry.shared),
          );
        });
  }

  @override
  Map<String, Function> getVariables() {
    return {};
  }
}
