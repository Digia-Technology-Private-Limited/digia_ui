import 'package:flutter/material.dart';

import '../utils/debouncer.dart';
import '../utils/functional_util.dart';

class ValidationIssue {
  final String type;
  final dynamic data;
  final String errorMessage;

  ValidationIssue({
    required this.type,
    this.data,
    required this.errorMessage,
  });
}

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
  final List<ValidationIssue>? validations;
  final Color? cursorColor;
  final void Function(String)? onChanged;
  final InputDecoration? inputDecoration;
  final int? debounceValue;

  const InternalTextFormField({
    super.key,
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
    this.inputDecoration = const InputDecoration(),
    this.debounceValue,
    this.validations,
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

  String? validateField(String? value, List<ValidationIssue>? validations) {
    if (validations != null) {
      for (final rule in validations) {
        switch (rule.type) {
          case 'required':
            if (value == null || value.trim().isEmpty) {
              return rule.errorMessage;
            }
            break;

          case 'minLength':
            if (value != null && value.length < (rule.data as int)) {
              return rule.errorMessage;
            }
            break;

          case 'maxLength':
            if (value != null && value.length > (rule.data as int)) {
              return rule.errorMessage;
            }
            break;

          case 'pattern':
            if (value != null && value.isNotEmpty) {
              final regExp = RegExp(rule.data as String);
              if (!regExp.hasMatch(value)) {
                return rule.errorMessage;
              }
            }
            break;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autoFocus ?? false,
      autovalidateMode: AutovalidateMode.always,
      controller: widget.controller,
      enabled: widget.enabled,
      initialValue: widget.initialValue,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: widget.style,
      textAlign: widget.textAlign,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      validator: (value) => validateField(value, widget.validations),
      cursorColor: widget.cursorColor,
      onChanged: _onChanged,
      onFieldSubmitted: (value) {
        widget.onSubmit?.call(value);
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
}
