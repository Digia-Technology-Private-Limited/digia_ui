import 'package:flutter/material.dart';

import '../utils/debouncer.dart';
import '../utils/functional_util.dart';

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
  final bool? autoFocus;
  final void Function(String)? onSubmit;

  final Color? cursorColor;
  final String? regex;
  final String? errorText;
  final void Function(String)? onChanged;
  final InputDecoration? inputDecoration;
  final int? debounceValue;

  const InternalTextFormField(
      {super.key,
      this.autoFocus,
      this.enabled,
      this.keyboardType,
      this.textInputAction,
      this.style,
      this.onChanged,
      this.onSubmit,
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
      this.debounceValue
      // this.onChanged,
      });

  @override
  State<InternalTextFormField> createState() => _DUITextFieldState();
}

class _DUITextFieldState extends State<InternalTextFormField> {
  Debouncer? _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = widget.debounceValue.maybe((it) {
      if (it > 0) {
        return Debouncer(delay: Duration(milliseconds: it));
      }
      return null;
    });
  }

  void _onChanged(String value) {
    if (_debouncer != null) {
      _debouncer!.call(() {
        widget.onChanged?.call(value);
      });
    } else {
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
      autofocus: widget.autoFocus ?? false,
      controller: widget.controller,
      initialValue: widget.initialValue,
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
      validator: _validateInput,
      onChanged: _onChanged,
      buildCounter: (context,
              {required currentLength,
              required isFocused,
              required maxLength}) =>
          null,
      onFieldSubmitted: (value) {
        widget.onSubmit?.call(value);

        // FocusScopeNode focusScope = FocusScope.of(context);
        // if (!focusScope.hasPrimaryFocus && focusScope.canRequestFocus) {
        //   focusScope.nextFocus();
        // }
      },
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: widget.inputDecoration,
    );
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (widget.regex != null && widget.regex!.isNotEmpty) {
      RegExp regex = RegExp(widget.regex!);
      if (!regex.hasMatch(value)) {
        return widget.errorText;
      } else {
        return null;
      }
    }
    return null;
  }
}
