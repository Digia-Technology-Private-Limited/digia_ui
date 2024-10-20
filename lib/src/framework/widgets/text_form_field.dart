import 'package:flutter/material.dart';

import '../../Utils/util_functions.dart';
import '../../components/border/dashed_input_border/dashed_outline_input_border.dart';
import '../../components/border/dashed_input_border/dashed_underline_input_border.dart';
import '../../components/utils/DUIBorder/dui_border.dart';
import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../data_type/adapted_types/text_editing_controller.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_text_form_field.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWTextFormField extends VirtualStatelessWidget<Props> {
  VWTextFormField({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
    required super.childGroups,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    final controller =
        payload.eval<AdaptedTextEditingController>(props.get('controller')) ??
            AdaptedTextEditingController(
              text: payload.eval<String>(props.get('initialValue')),
            );

    final enabled = props.getBool('enabled');
    final keyboardType = To.toKeyBoardType(props.get('keyboardType'));
    final textInputAction = To.toTextInputAction(props.get('textInputAction'));
    final style = payload.getTextStyle(props.getMap('textStyle'));
    final textAlign =
        To.textAlign(payload.eval<String>(props.get('textAlign')));
    final readOnly = props.getBool('readOnly') ?? false;
    final obscureText = props.getBool('obscureText') ?? false;
    final maxLines = props.getInt('maxLines');
    final minLines = props.getInt('minLines');
    final maxLength = props.getInt('maxLength');
    final fillColor = payload.evalColor(props.get('fillColor'));
    final labelText = props.getString('labelText');
    final labelStyle = payload.getTextStyle(props.getMap('labelStyle'));
    final hintText = props.getString('hintText');
    final hintStyle = payload.getTextStyle(props.getMap('hintStyle'));
    final contentPadding = To.edgeInsets(props.get('contentPadding'));
    final focusColor = payload.evalColor(props.get('focusColor'));
    final cursorColor = payload.evalColor(props.get('cursorColor'));
    final regex = payload.eval<String>(props.getString('regex'));
    final errorText = props.getString('errorText');
    final errorStyle = payload.getTextStyle(props.getMap('errorStyle'));
    final enabledBorder = _toInputBorder(props.get('enabledBorder'));
    final disabledBorder = _toInputBorder(props.get('disabledBorder'));
    final focusedBorder = _toInputBorder(props.get('focusedBorder'));
    final focusedErrorBorder = _toInputBorder(props.get('focusedErrorBorder'));
    final errorBorder = _toInputBorder(props.get('errorBorder'));
    return InternalTextFormField(
      controller: controller,
      onChangedAction: (p0, p1) async {
        final actionFlow = ActionFlow.fromJson(props.get('onChanged'));
        await payload.executeAction(actionFlow,
            scopeContext: _createExprContext(p0, p1));
      },
      // onChanged: (p0, p1) => _createExprContext(p0, p1),
      textAlign: textAlign,
      readOnly: readOnly,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      cursorColor: cursorColor,
      regex: regex,
      errorText: errorText,
      inputDecoration: InputDecoration(
        fillColor: fillColor,
        filled: fillColor != null,
        labelText: labelText,
        labelStyle: labelStyle,
        errorStyle: errorStyle,
        hintText: hintText,
        hintStyle: hintStyle,
        contentPadding: minLines != null
            ? (minLines > 1 ? const EdgeInsets.all(12) : contentPadding)
            : contentPadding,
        focusColor: focusColor,
        prefixIcon: childOf('prefix')?.toWidget(payload),
        suffixIcon: childOf('suffix')?.toWidget(payload),
        enabledBorder: enabledBorder,
        disabledBorder: disabledBorder,
        focusedBorder: focusedBorder,
        focusedErrorBorder: focusedErrorBorder,
        errorBorder: errorBorder,
      ),
    );
  }

  InputBorder? _toInputBorder(dynamic border) {
    if (border == null || border is! Map) return null;

    BorderRadius borderRadius = To.borderRadius(border['borderRadius']);

    BorderSide borderSide = toBorderSide(DUIBorder.fromJson({
      'borderStyle': border['borderStyle'],
      'borderWidth': border['borderWidth'],
      'borderColor': border['borderColor'],
      'borderRadius': border['borderRadius'],
    }));

    final borderType = border['borderType']['value'];

    switch (borderType) {
      case 'outlineInputBorder':
        return OutlineInputBorder(
          borderSide: borderSide,
          borderRadius: borderRadius,
        );
      case 'underlineInputBorder':
        return UnderlineInputBorder(
          borderSide: borderSide,
          borderRadius: borderRadius,
        );
      case 'outlineDashedInputBorder':
        return DashedOutlineInputBorder(
          borderSide: borderSide,
          borderRadius: borderRadius,
          strokeCap:
              To.strokeCap(border['borderType']['strokeCap']) ?? StrokeCap.butt,
          dashPattern: To.dashPattern(border['borderType']['dashPattern']) ??
              const [3, 3],
        );
      case 'underlineDashedInputBorder':
        return DashedUnderlineInputBorder(
          borderSide: borderSide,
          borderRadius: borderRadius,
          strokeCap:
              To.strokeCap(border['borderType']['strokeCap']) ?? StrokeCap.butt,
          dashPattern: To.dashPattern(border['borderType']['dashPattern']) ??
              const [3, 3],
        );
      default:
        return InputBorder.none;
    }
  }

  ScopeContext _createExprContext(String text, bool isValid) {
    return DefaultScopeContext(variables: {
      'text': text,
      'isValid': isValid,
    });
  }
}
