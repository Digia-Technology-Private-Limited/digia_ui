import 'package:flutter/material.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../custom/dashed_outline_input_border.dart';
import '../custom/dashed_underline_input_border.dart';
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
    super.parentProps,
    required super.parent,
    super.refName,
    required super.childGroups,
  });

  @override
  Widget render(RenderPayload payload) {
    final controller =
        payload.eval<AdaptedTextEditingController>(props.get('controller'));

    final autoFocus = payload.eval<bool>(props.get('autoFocus'));
    final enabled = props.getBool('enabled');
    final keyboardType = To.toKeyBoardType(props.get('keyboardType'));
    final textInputAction = To.toTextInputAction(props.get('textInputAction'));
    final style = payload.getTextStyle(props.getMap('textStyle'));
    final textAlign =
        To.textAlign(payload.eval<String>(props.get('textAlign')));
    final readOnly = props.getBool('readOnly') ?? false;
    final obscureText = payload.eval<bool>(props.get('obscureText')) ?? false;
    final maxLines = props.getInt('maxLines');
    final minLines = props.getInt('minLines');
    final maxLength = props.getInt('maxLength');
    final effectiveMaxLines = obscureText ? 1 : maxLines;
    final effectiveMinLines = obscureText ? 1 : minLines;
    final isMultiline = (effectiveMinLines ?? 1) > 1;
    final fillColor = payload.evalColor(props.get('fillColor'));
    final labelText = payload.eval<String>(props.get('labelText'));
    final labelStyle = payload.getTextStyle(props.getMap('labelStyle'));
    final hintText = payload.eval<String>(props.get('hintText'));
    final hintStyle = payload.getTextStyle(props.getMap('hintStyle'));
    final contentPadding = To.edgeInsets(props.get('contentPadding'));
    final focusColor = payload.evalColor(props.get('focusColor'));
    final cursorColor = payload.evalColor(props.get('cursorColor'));
    final validations = props.getList('validationRules')?.map(
      (Object? e) {
        final map = e as Map?;
        return ValidationIssue(
          type: map?['type'],
          errorMessage: payload.eval<String>(map?['errorMessage']) ?? '',
          data: payload.eval(map?['data']),
        );
      },
    ).toList();

    final errorStyle = payload.getTextStyle(props.getMap('errorStyle'));
    final enabledBorder = _toInputBorder(payload, props.get('enabledBorder'));
    final disabledBorder = _toInputBorder(payload, props.get('disabledBorder'));
    final focusedBorder = _toInputBorder(payload, props.get('focusedBorder'));
    final focusedErrorBorder =
        _toInputBorder(payload, props.get('focusedErrorBorder'));
    final errorBorder = _toInputBorder(payload, props.get('errorBorder'));

    // building prefix and suffix widgets with proper constraints
    final prefixWidget = _buildConstrainedIcon(childOf('prefix')?.toWidget(payload));
    final suffixWidget = _buildConstrainedIcon(childOf('suffix')?.toWidget(payload));

    return InternalTextFormField(
      controller: controller,
      autoFocus: autoFocus,
      initialValue: payload.eval<String>(props.get('initialValue')),
      debounceValue: props.getInt('debounceValue'),
      onChanged: (p0) async {
        final actionFlow = ActionFlow.fromJson(props.get('onChanged'));
        await payload.executeAction(
          actionFlow,
          scopeContext: _createExprContext(p0),
          triggerType: 'onChanged',
        );
      },
      onSubmit: (p0) async {
        final actionFlow = ActionFlow.fromJson(props.get('onSubmit'));
        await payload.executeAction(
          actionFlow,
          scopeContext: _createExprContext(p0),
          triggerType: 'onSubmit',
        );
      },
      textAlign: textAlign,
      textAlignVertical: TextAlignVertical.center,
      readOnly: readOnly,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: style,
      maxLines:
          effectiveMaxLines, // Ensuring the effective maxLines and minLines are dynamically set as per the obscureText
      minLines: effectiveMinLines,
      maxLength: maxLength,
      cursorColor: cursorColor,
      validations: validations,
      inputDecoration: InputDecoration(
        isDense: true,
        fillColor: fillColor,
        filled: fillColor != null,
        labelText: labelText,
        labelStyle: labelStyle,
        errorStyle: errorStyle,
        hintText: hintText,
        hintStyle: hintStyle,
        contentPadding: isMultiline ? const EdgeInsets.all(12) : contentPadding,
        focusColor: focusColor,
        prefixIcon: prefixWidget,
        suffixIcon: suffixWidget,
        prefixIconConstraints: prefixWidget != null
            ? const BoxConstraints(minWidth: 0, minHeight: 0)
            : null,
        suffixIconConstraints: suffixWidget != null
            ? const BoxConstraints(minWidth: 0, minHeight: 0)
            : null,
        enabledBorder: enabledBorder,
        disabledBorder: disabledBorder,
        focusedBorder: focusedBorder,
        focusedErrorBorder: focusedErrorBorder,
        errorBorder: errorBorder,
      ),
    );
  }

  InputBorder? _toInputBorder(RenderPayload payload, dynamic border) {
    if (border == null || border is! Map) return null;

    BorderRadius borderRadius = To.borderRadius(border['borderRadius']);

    BorderSide borderSide =
        To.borderSide(border, evalColor: payload.evalColor) ?? BorderSide.none;

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

  ScopeContext _createExprContext(String text) {
    return DefaultScopeContext(variables: {
      'text': text,
    });
  }

  // Add this helper method
  Widget? _buildConstrainedIcon(Widget? iconWidget) {
    if (iconWidget == null) return null;

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 48,
        maxHeight: 48,
      ),
      alignment: Alignment.center,
      child: ClipRect(
        child: iconWidget,
      ),
    );
  }
}
