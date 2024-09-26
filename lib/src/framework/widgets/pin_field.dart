import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_pin_field.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/types.dart';

class VWPinField extends VirtualLeafStatelessWidget<Props> {
  VWPinField({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final length = payload.eval<int>(props.get('length')) ?? 4;
    final autoFocus = payload.eval<bool>(props.get('autoFocus')) ?? false;
    final enabled = payload.eval<bool>(props.get('enabled')) ?? true;
    final defaultPinTheme = props.getMap('defaultPinTheme');

    if (defaultPinTheme?.containsKey('textStyle') ?? false) {
      (defaultPinTheme?['textStyle'] as Map)
          .removeWhere((key, value) => value == null || value == 'none');
      if ((defaultPinTheme?['textStyle'] as Map).isEmpty) {
        defaultPinTheme?['textStyle'] = null;
      }
    }
    defaultPinTheme?.removeWhere((key, value) => value == null);
    final obscureText = payload.eval<bool>(props.get('obscureText')) ?? false;
    return InternalPinField(
      length: length,
      autoFocus: autoFocus,
      enabled: enabled,
      obscureText: obscureText,
      onChanged: (pinValue) async {
        _createExprContext(pinValue);
        final actionFlow = ActionFlow.fromJson(props.get('onChanged'));
        await payload.executeAction(actionFlow,
            exprContext: _createExprContext(pinValue));
      },
      onCompleted: (pinValue) async {
        final actionFlow = ActionFlow.fromJson(props.get('onCompleted'));
        await payload.executeAction(actionFlow,
            exprContext: _createExprContext(pinValue));
      },
      pinTheme: defaultPinTheme == null || defaultPinTheme.isEmpty
          ? null
          : PinFieldTheme(
              width: payload.eval<double>(defaultPinTheme['width']) ?? 56,
              height: payload.eval<double>(defaultPinTheme['height']) ?? 60,
              margin: To.edgeInsets(defaultPinTheme['margin']),
              padding: To.edgeInsets(defaultPinTheme['padding']),
              textStyle: payload
                  .getTextStyle(defaultPinTheme['textStyle'] as JsonLike?),
              fillColor: payload.evalColor(defaultPinTheme['fillColor']),
              borderColor: payload.evalColor(defaultPinTheme['borderColor']) ??
                  const Color(0xFF000000),
              borderRadius: To.borderRadius(defaultPinTheme['borderRadius']),
              borderWidth:
                  payload.eval<double>(defaultPinTheme['borderWidth']) ?? 1,
            ),
    );
  }

  ExprContext _createExprContext(String text) {
    return ExprContext(variables: {
      'pin': text,
    });
  }
}
