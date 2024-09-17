import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../core/extensions.dart';
import '../core/virtual_stateless_widget.dart';
import '../internal_widgets/internal_stepper.dart';
import '../models/props.dart';
import '../render_payload.dart';
import 'icon.dart';

class VWStepper extends VirtualStatelessWidget {
  VWStepper({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    required super.repeatData,
  });

  bool get shouldRepeatChild => repeatData != null;

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    final animationTimeInSeconds =
        payload.eval<int>(props.get('animationTimeInSeconds'));
    final completedStepIndex =
        payload.eval<double>(props.get('completedIndex'));
    final indicatorPosition =
        payload.eval<double>(props.get('indicatorPosition'));
    final radius = payload.eval<double>(props.get('radius'));
    final thickness = payload.eval<double>(props.get('thickness'));
    final completedColor = payload.eval<String>(props.get('completedColor'));
    final inCompletedColor =
        payload.eval<String>(props.get('inCompletedColor'));
    final completedConnector = props.getMap('completedConnector');
    final inCompletedConnector = props.getMap('inCompletedConnector');
    final completedIcon = props.getMap('completedIcon').isNotNull
        ? VWIcon(
                props: Props(props.getMap('completedIcon')!),
                commonProps: commonProps,
                parent: parent)
            .render(payload)
        : null;
    final inCompletedIcon = props.getMap('inCompletedIcon').isNotNull
        ? VWIcon(
                props: Props(props.getMap('inCompletedIcon')!),
                commonProps: commonProps,
                parent: parent)
            .render(payload)
        : null;
    final pendingIcon = props.getMap('pendingIcon').isNotNull
        ? VWIcon(
                props: Props(props.getMap('pendingIcon')!),
                commonProps: commonProps,
                parent: parent)
            .render(payload)
        : null;

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.evalRepeatData(repeatData!);
      return InternalStepper(
        animationTimeInSeconds: animationTimeInSeconds,
        completedIndex: completedStepIndex,
        completedConnector: ConnectorValue(
          connectorType: ConnectorValue.toConnectorType(
            completedConnector?['value'],
          ),
          color: makeColor(completedConnector?['color']),
          dash: (completedConnector?['dash']).tryCast(),
          gap: (completedConnector?['gap']).tryCast(),
          strokeCap: toStrokeCap(completedConnector?['strokeCap']),
        ),
        inCompletedConnector: ConnectorValue(
          connectorType: ConnectorValue.toConnectorType(
            inCompletedConnector?['value'],
          ),
          color: makeColor(inCompletedConnector?['color']),
          dash: (inCompletedConnector?['dash']).tryCast(),
          gap: (inCompletedConnector?['gap']).tryCast(),
          strokeCap: toStrokeCap(inCompletedConnector?['strokeCap']),
        ),
        indicatorPosition: indicatorPosition,
        radius: radius,
        thickness: thickness,
        completedColor: makeColor(completedColor),
        inCompletedColor: makeColor(inCompletedColor),
        completedIcon: completedIcon,
        inCompletedIcon: inCompletedIcon,
        pendingIcon: pendingIcon,
        itemCount: items.length,
        itemBuilder: (buildContext, index) => childToRepeat.toWidget(
          payload.copyWithChainedContext(
            _createExprContext(items[index], index),
          ),
        ),
      );
    }

    return InternalStepper(
      animationTimeInSeconds: animationTimeInSeconds,
      completedIndex: completedStepIndex,
      completedConnector: ConnectorValue(
        connectorType: ConnectorValue.toConnectorType(
          completedConnector?['value'],
        ),
        color: makeColor(completedConnector?['color']),
        dash: (completedConnector?['dash']).tryCast(),
        gap: (completedConnector?['gap']).tryCast(),
        strokeCap: toStrokeCap(completedConnector?['strokeCap']),
      ),
      inCompletedConnector: ConnectorValue(
        connectorType: ConnectorValue.toConnectorType(
          inCompletedConnector?['value'],
        ),
        color: makeColor(inCompletedConnector?['color']),
        dash: (inCompletedConnector?['dash']).tryCast(),
        gap: (inCompletedConnector?['gap']).tryCast(),
        strokeCap: toStrokeCap(inCompletedConnector?['strokeCap']),
      ),
      indicatorPosition: indicatorPosition,
      radius: radius,
      thickness: thickness,
      completedColor: makeColor(completedColor),
      inCompletedColor: makeColor(inCompletedColor),
      completedIcon: completedIcon,
      inCompletedIcon: inCompletedIcon,
      pendingIcon: pendingIcon,
      itemCount: (children?.toWidgetArray(payload) ?? []).length,
      children: children?.toWidgetArray(payload) ?? [],
    );
  }

  ExprContext _createExprContext(Object? item, int index) {
    return ExprContext(variables: {'currentItem': item, 'index': index});
  }
}
