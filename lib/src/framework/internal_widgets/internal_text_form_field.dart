import 'dart:async';

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
  final int debounceValue;

  const InternalTextFormField(
      {super.key,
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
      required this.debounceValue
      // this.onChanged,
      });

  @override
  State<InternalTextFormField> createState() => _DUITextFieldState();
}

class _DUITextFieldState extends State<InternalTextFormField> {
  late TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  void _setupController() {
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  void _tearDownController() {
    // Don't dispose the _controller. It may be an external controller.
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: widget.debounceValue), () {
      widget.onChanged?.call(value);
    });
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
      onChanged: _onChanged,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: widget.inputDecoration,
    );
  }

  @override
  void dispose() {
    _tearDownController();
    _debounce?.cancel();
    super.dispose();
  }
}
