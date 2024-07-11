import 'dart:ui';

import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../core/action/action_handler.dart';
import '../../core/action/action_prop.dart';
import '../../core/evaluator.dart';
import '../DUIText/dui_text_style.dart';
import '../dui_base_stateful_widget.dart';
import '../utils/DUIBorder/dui_border.dart';
import '../utils/dottedInputBorder.dart';

class DUITextFormField extends BaseStatefulWidget {
  final Map<String, dynamic> props;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const DUITextFormField({
    super.key,
    required super.varName,
    required this.props,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<DUITextFormField> createState() => _DUITextFieldState();
}

class _DUITextFieldState extends DUIWidgetState<DUITextFormField> {
  late TextEditingController _controller;
  bool? _enabled;
  TextInputType? _keyboardType;
  TextInputAction? _textInputAction;
  TextStyle? _style;
  late TextAlign _textAlign;
  bool _readOnly = false;
  bool _obscureText = false;
  int? _maxLines;
  int? _minLines;
  int? _maxLength;

  Color? _fillColor;
  String? _labelText;
  TextStyle? _labelStyle;
  TextStyle? _hintStyle;
  TextStyle? _errorStyle;
  String? _hintText;
  EdgeInsets? _contentPadding;
  Color? _focusColor;
  Color? _cursorColor;
  String? _regex;
  String? _errorText;
  String? _setErrorText = null;

  InputBorder? _enabledBorder;
  InputBorder? _disabledBorder;
  InputBorder? _focusedBorder;
  InputBorder? _focusedErrorBorder;
  InputBorder? _errorBorder;

  @override
  void initState() {
    _controller = TextEditingController(
        text: eval(widget.props['initialValue'], context: context));
    _controller.addListener(() async {
      final onClick = ActionFlow.fromJson(widget.props['onChanged']);
      await ActionHandler.instance
          .execute(context: context, actionFlow: onClick);
    });
    _enabled = NumDecoder.toBool(widget.props['enabled']);
    _keyboardType = DUIDecoder.toKeyBoardType(widget.props['keyboardType']);
    _textInputAction =
        DUIDecoder.toTextInputAction(widget.props['textInputAction']);
    _style =
        toTextStyle(DUITextStyle.fromJson(widget.props['textStyle']), context);
    _textAlign = DUIDecoder.toTextAlign(widget.props['textAlign']);
    _readOnly = NumDecoder.toBool(widget.props['readOnly']) ?? false;
    _obscureText = NumDecoder.toBool(widget.props['obscureText']) ?? false;
    _maxLines = NumDecoder.toInt(widget.props['maxLines']);
    _minLines = NumDecoder.toInt(widget.props['minLines']);
    _maxLength = NumDecoder.toInt(widget.props['maxLength']);
    _fillColor = makeColor(widget.props['fillColor']);
    _labelText = widget.props['labelText'] as String?;
    _labelStyle =
        toTextStyle(DUITextStyle.fromJson(widget.props['labelStyle']), context);
    _hintText = widget.props['hintText'] as String?;
    _hintStyle =
        toTextStyle(DUITextStyle.fromJson(widget.props['hintStyle']), context);
    _contentPadding = DUIDecoder.toEdgeInsets(widget.props['contentPadding']);
    _focusColor = makeColor(widget.props['focusColor']);
    _cursorColor = makeColor(widget.props['cursorColor']);
    _regex = widget.props['regex'] as String?;
    _errorText = widget.props['errorText'] as String?;
    _errorStyle =
        toTextStyle(DUITextStyle.fromJson(widget.props['errorStyle']), context);
    _enabledBorder = _toInputBorder(widget.props['enabledBorder']);
    _disabledBorder = _toInputBorder(widget.props['disabledBorder']);
    _focusedBorder = _toInputBorder(widget.props['focusedBorder']);
    _focusedErrorBorder = _toInputBorder(widget.props['focusedErrorBorder']);
    _errorBorder = _toInputBorder(widget.props['errorBorder']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      enabled: _enabled,
      keyboardType: _keyboardType,
      textInputAction: _textInputAction,
      style: _style,
      textAlign: _textAlign,
      obscureText: _obscureText,
      readOnly: _readOnly,
      maxLines: _maxLines,
      minLines: _minLines,
      maxLength: _maxLength,
      cursorColor: _cursorColor,
      buildCounter: (context,
              {required currentLength,
              required isFocused,
              required maxLength}) =>
          null,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        fillColor: _fillColor,
        filled: _fillColor != null,
        labelText: _labelText,
        labelStyle: _labelStyle,
        errorStyle: _errorStyle,
        hintText: _hintText,
        hintStyle: _hintStyle,
        contentPadding: _minLines != null
            ? (_minLines! > 1 ? const EdgeInsets.all(12) : _contentPadding)
            : _contentPadding,
        focusColor: _focusColor,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        enabledBorder: _enabledBorder,
        disabledBorder: _disabledBorder,
        focusedBorder: _focusedBorder,
        focusedErrorBorder: _focusedErrorBorder,
        errorBorder: _errorBorder,
        errorText: _setErrorText,
      ),
      onChanged: (value) {
        _validateInput(value);
      },
    );
  }

  String _convertRawStringToRegexPattern(String rawString) {
    if (rawString.startsWith("r'") && rawString.endsWith("'")) {
      return rawString.substring(2, rawString.length - 1);
    }
    return rawString;
  }

  void _validateInput(String value) {
    if (value.isEmpty) {
      setState(() {
        _setErrorText = null;
      });
      return;
    }
    if (_regex != null && _regex!.isNotEmpty) {
      String regexSource = _convertRawStringToRegexPattern(_regex!);
      RegExp regex = RegExp(regexSource);
      if (!regex.hasMatch(value)) {
        setState(() {
          _setErrorText = _errorText;
        });
      } else {
        setState(() {
          _setErrorText = null;
        });
      }
    }
  }

  InputBorder? _toInputBorder(dynamic border) {
    if (border == null || border is! Map) return null;

    BorderRadius borderRadius =
        DUIDecoder.toBorderRadius(border['borderRadius']);

    BorderSide borderSide = toBorderSide(DUIBorder.fromJson(border));
    switch (border['borderType']) {
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
      case 'outlineDottedInputBorder':
        return DottedInputBorder(
          inputBorderType: InputBorderType.outline,
          borderType: BorderType.dotted,
          borderSide: borderSide,
          borderRadius: borderRadius,
        );
      case 'underlineDottedInputBorder':
        return DottedInputBorder(
          inputBorderType: InputBorderType.underline,
          borderType: BorderType.dotted,
          borderSide: borderSide,
          borderRadius: borderRadius,
        );
      default:
        return InputBorder.none;
    }
  }

  @override
  Map<String, Function> getVariables() {
    return {'text': () => _controller.text};
  }
}
