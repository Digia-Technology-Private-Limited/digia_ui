import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../core/evaluator.dart';
import '../DUIText/dui_text_style.dart';
import '../dui_base_stateful_widget.dart';
import '../utils/DUIBorder/dui_border.dart';

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
  String? _hintText;
  EdgeInsets? _contentPadding;
  Color? _focusColor;
  Color? _cursorColor;

  InputBorder? _enabledBorder;
  InputBorder? _disabledBorder;
  InputBorder? _focusedBorder;
  InputBorder? _focusedErrorBorder;
  InputBorder? _errorBorder;

  @override
  void initState() {
    _controller = TextEditingController(
        text: eval(widget.props['initialValue'], context: context));
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
    _contentPadding = DUIDecoder.toEdgeInsets(widget.props['contentPadding']);
    _focusColor = makeColor(widget.props['focusColor']);
    _cursorColor = makeColor(widget.props['cursorColor']);
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
      decoration: InputDecoration(
        fillColor: _fillColor,
        filled: _fillColor != null,
        labelText: _labelText,
        labelStyle: _labelStyle,
        hintText: _hintText,
        contentPadding: _contentPadding,
        focusColor: _focusColor,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        enabledBorder: _enabledBorder,
        disabledBorder: _disabledBorder,
        focusedBorder: _focusedBorder,
        focusedErrorBorder: _focusedErrorBorder,
        errorBorder: _errorBorder,
      ),
    );
  }

  InputBorder? _toInputBorder(dynamic border) {
    if (border == null || border is! Map) return null;

    BorderRadius borderRadius =
        DUIDecoder.toBorderRadius(border['borderRadius']);

    BorderSide borderSide = toBorderSide(DUIBorder.fromJson(border));
    switch (border['borderType']) {
      case 'outline':
        return OutlineInputBorder(
          borderSide: borderSide,
          borderRadius: borderRadius,
        );
      case 'underline':
        return UnderlineInputBorder(
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
