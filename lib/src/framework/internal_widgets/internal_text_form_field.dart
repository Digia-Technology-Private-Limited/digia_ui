import 'package:flutter/material.dart';

class InternalTextFormField extends StatefulWidget {
  final TextEditingController? controller;
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

  final Color? cursorColor;
  final String? regex;
  final String? errorText;
  final void Function(String)? onChanged;
  final InputDecoration? inputDecoration;

  const InternalTextFormField({
    super.key,
    this.enabled,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.onChanged,
    this.initialValue,
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
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  void _setupController() {
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _controller.addListener(_onChanged);
  }

  void _tearDownController() {
    // Don't dispose the _controller. It may be an external controller.
    _controller.removeListener(_onChanged);
  }

  void _onChanged() {
    widget.onChanged?.call(_controller.text);
  }

  @override
  void didUpdateWidget(covariant InternalTextFormField oldWidget) {
    if (widget.controller != oldWidget.controller ||
        widget.initialValue != oldWidget.initialValue) {
      _tearDownController();
      _setupController();
    }

    super.didUpdateWidget(oldWidget);
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
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: widget.inputDecoration,
    );
  }

  @override
  void dispose() {
    _tearDownController();
    super.dispose();
  }
}
