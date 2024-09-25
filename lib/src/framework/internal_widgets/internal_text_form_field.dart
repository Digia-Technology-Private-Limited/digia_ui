import 'package:flutter/material.dart';

class InternalTextFormField extends StatefulWidget {
  final String? initialValue;
  final bool? enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool readOnly;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  final Color? fillColor;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final String? hintText;
  final EdgeInsets? contentPadding;
  final Color? focusColor;
  final Color? cursorColor;
  final String? regex;
  final String? errorText;
  final Function(String, bool)? onChangedAction;
  // final Function(String, bool)? onChanged;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const InternalTextFormField({
    super.key,
    this.enabled,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.onChangedAction,
    required this.textAlign,
    required this.readOnly,
    required this.obscureText,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.fillColor,
    this.labelText,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.hintText,
    this.contentPadding,
    this.focusColor,
    this.cursorColor,
    this.regex,
    this.errorText,
    this.enabledBorder,
    this.disabledBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.errorBorder,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    // this.onChanged,
  });

  @override
  State<InternalTextFormField> createState() => _DUITextFieldState();
}

class _DUITextFieldState extends State<InternalTextFormField> {
  late TextEditingController _controller;
  String? _setErrorText;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() {
      widget.onChangedAction
          ?.call(_controller.text, _setErrorText == null ? true : false);
    });
    // _keyboardType = DUIDecoder.toKeyBoardType(widget.props['keyboardType']);
    // _textInputAction =
    //     DUIDecoder.toTextInputAction(widget.props['textInputAction']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: widget.style,
      textAlign: widget.textAlign,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      cursorColor: widget.cursorColor,
      buildCounter: (context,
              {required currentLength,
              required isFocused,
              required maxLength}) =>
          null,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        fillColor: widget.fillColor,
        filled: widget.fillColor != null,
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        errorStyle: widget.errorStyle,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        contentPadding: widget.minLines != null
            ? (widget.minLines! > 1
                ? const EdgeInsets.all(12)
                : widget.contentPadding)
            : widget.contentPadding,
        focusColor: widget.focusColor,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        enabledBorder: widget.enabledBorder,
        disabledBorder: widget.disabledBorder,
        focusedBorder: widget.focusedBorder,
        focusedErrorBorder: widget.focusedErrorBorder,
        errorBorder: widget.errorBorder,
        errorText: _setErrorText,
      ),
      onChanged: (value) {
        _validateInput(value);
        // widget.onChanged
        //     ?.call(_controller.text, _setErrorText == null ? true : false);
      },
    );
  }

  void _validateInput(String value) {
    if (value.isEmpty) {
      setState(() {
        _setErrorText = null;
      });
      return;
    }
    if (widget.regex != null && widget.regex!.isNotEmpty) {
      RegExp regex = RegExp(widget.regex!);
      if (!regex.hasMatch(value)) {
        setState(() {
          _setErrorText = widget.errorText;
        });
      } else {
        setState(() {
          _setErrorText = null;
        });
      }
    }
  }
}
