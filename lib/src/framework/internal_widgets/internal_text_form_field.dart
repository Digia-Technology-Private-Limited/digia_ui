import 'package:flutter/material.dart';

class InternalTextFormField extends StatefulWidget {
  final TextEditingController controller;
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

  final Color? cursorColor;
  final String? regex;
  final String? errorText;
  final Function(String, bool)? onChangedAction;
  // final Function(String, bool)? onChanged;
  final InputDecoration? inputDecoration;

  const InternalTextFormField({
    super.key,
    this.enabled,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.onChangedAction,
    required this.controller,
    required this.textAlign,
    required this.readOnly,
    required this.obscureText,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.cursorColor,
    this.regex,
    this.errorText,
    this.inputDecoration = const InputDecoration(),
    // this.onChanged,
  });

  @override
  State<InternalTextFormField> createState() => _DUITextFieldState();
}

class _DUITextFieldState extends State<InternalTextFormField> {
  String? _setErrorText;

  @override
  void initState() {
    widget.controller.addListener(_onChanged);
    super.initState();
  }

  _onChanged() {
    widget.onChangedAction?.call(
      widget.controller.text,
      _setErrorText == null ? true : false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
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
      decoration: widget.inputDecoration?..copyWith(errorText: _setErrorText),
      onChanged: (value) {
        _validateInput(value);
      },
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
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
