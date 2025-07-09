import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pinput/pinput.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/pin_field.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';
import '../widget_props/pin_field_props.dart';

class VWPinField extends VirtualLeafStatelessWidget<PinFieldProps> {
  VWPinField({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final length = payload.evalExpr(props.length) ?? 4;
    final autoFocus = payload.evalExpr(props.autoFocus) ?? false;
    final enabled = payload.evalExpr(props.enabled) ?? true;
    final obscureText = payload.evalExpr(props.obscureText) ?? false;
    final defaultPinTheme = props.defaultPinTheme;

    return PinField(
      length: length,
      autoFocus: autoFocus,
      enabled: enabled,
      obscureText: obscureText,
      // TODO: Add support for filtering input formatters on dashboard.
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (pinValue) async {
        // _createExprContext(pinValue);
        await payload.executeAction(
          props.onChanged,
          scopeContext: _createExprContext(pinValue),
        );
      },
      onCompleted: (pinValue) async {
        await payload.executeAction(
          props.onCompleted,
          scopeContext: _createExprContext(pinValue),
        );
      },
      pinTheme: PinTheme(
        width: payload.eval<double>(defaultPinTheme?['width']) ?? 56,
        height: payload.eval<double>(defaultPinTheme?['height']) ?? 60,
        margin: To.edgeInsets(defaultPinTheme?['margin']),
        padding: To.edgeInsets(defaultPinTheme?['padding']),
        textStyle:
            payload.getTextStyle(as$<JsonLike>(defaultPinTheme?['textStyle'])),
        decoration: BoxDecoration(
          color: payload.evalColor(defaultPinTheme?['fillColor']),
          borderRadius: To.borderRadius(
            defaultPinTheme?['borderRadius'],
            or: BorderRadius.circular(8),
          ),
          border: Border.all(
            color: payload.evalColor(defaultPinTheme?['borderColor']) ??
                const Color(0xFF000000),
            width: payload.eval<double>(defaultPinTheme?['borderWidth']) ?? 1,
          ),
        ),
      ),
    );
  }

  ScopeContext _createExprContext(String text) {
    return DefaultScopeContext(variables: {
      'pin': text,
    });
  }
}
