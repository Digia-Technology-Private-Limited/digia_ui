import 'package:flutter/widgets.dart';

import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_stepper.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import '../utils/object_util.dart';
import '../widget_props/icon_props.dart';
import 'icon.dart';

class VWStepper extends VirtualStatelessWidget<Props> {
  VWStepper({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  bool get shouldRepeatChild => props.get('dataSource') != null;

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
    final completedIcon = props.getMap('completedIcon') != null
        ? VWIcon(
                props: IconProps.fromJson(props.getMap('inCompletedIcon')!) ??
                    IconProps.empty(),
                commonProps: null,
                parent: parent)
            .render(payload)
        : null;
    final inCompletedIcon = props.getMap('inCompletedIcon') != null
        ? VWIcon(
                props: IconProps.fromJson(props.getMap('inCompletedIcon')!) ??
                    IconProps.empty(),
                commonProps: null,
                parent: parent)
            .render(payload)
        : null;
    final pendingIcon = props.getMap('pendingIcon') != null
        ? VWIcon(
                props: IconProps.fromJson(props.getMap('pendingIcon')!) ??
                    IconProps.empty(),
                commonProps: null,
                parent: parent)
            .render(payload)
        : null;

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.eval<List<Object>>(props.get('dataSource')) ?? [];
      return InternalStepper(
        animationTimeInSeconds: animationTimeInSeconds,
        completedIndex: completedStepIndex,
        completedConnector: ConnectorValue(
          connectorType: ConnectorValue.toConnectorType(
            completedConnector?['value'],
          ),
          color: (completedConnector?['color']).to<Color>(),
          dash: (completedConnector?['dash']).to<double>(),
          gap: (completedConnector?['gap']).to<double>(),
          strokeCap: toStrokeCap(completedConnector?['strokeCap']),
        ),
        inCompletedConnector: ConnectorValue(
          connectorType: ConnectorValue.toConnectorType(
            inCompletedConnector?['value'],
          ),
          color: inCompletedConnector?['color']
              .to<String>()
              .maybe(payload.getColor),
          dash: (inCompletedConnector?['dash']).to<double>(),
          gap: (inCompletedConnector?['gap']).to<double>(),
          strokeCap: toStrokeCap(inCompletedConnector?['strokeCap']),
        ),
        indicatorPosition: indicatorPosition,
        radius: radius,
        thickness: thickness,
        completedColor: completedColor.to<String>().maybe(payload.getColor),
        inCompletedColor: inCompletedColor.to<String>().maybe(payload.getColor),
        completedIcon: completedIcon,
        inCompletedIcon: inCompletedIcon,
        pendingIcon: pendingIcon,
        itemCount: items.length,
        itemBuilder: (innerCtx, index) => childToRepeat.toWidget(
          payload.copyWithChainedContext(
            _createExprContext(items[index], index),
            buildContext: innerCtx,
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
        color:
            completedConnector?['color'].to<String>().maybe(payload.getColor),
        dash: (completedConnector?['dash']).to<double>(),
        gap: (completedConnector?['gap']).to<double>(),
        strokeCap: toStrokeCap(completedConnector?['strokeCap']),
      ),
      inCompletedConnector: ConnectorValue(
        connectorType: ConnectorValue.toConnectorType(
          inCompletedConnector?['value'],
        ),
        color:
            inCompletedConnector?['color'].to<String>().maybe(payload.getColor),
        dash: (inCompletedConnector?['dash']).to<double>(),
        gap: (inCompletedConnector?['gap']).to<double>(),
        strokeCap: toStrokeCap(inCompletedConnector?['strokeCap']),
      ),
      indicatorPosition: indicatorPosition,
      radius: radius,
      thickness: thickness,
      completedColor: completedColor.to<String>().maybe(payload.getColor),
      inCompletedColor: inCompletedColor.to<String>().maybe(payload.getColor),
      completedIcon: completedIcon,
      inCompletedIcon: inCompletedIcon,
      pendingIcon: pendingIcon,
      itemCount: (children?.toWidgetArray(payload) ?? []).length,
      children: children?.toWidgetArray(payload) ?? [],
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    return DefaultScopeContext(variables: {
      'currentItem': item,
      'index': index
      // TODO: Add class instance using refName
    });
  }
}
