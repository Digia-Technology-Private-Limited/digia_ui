// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final res = await smartAuth.getSmsCode();
    if (res.succeed && res.codeFound) {
      return res.code!;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}

class PinFieldTheme {
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final Color? fillColor;
  final Color borderColor;
  final BorderRadiusGeometry borderRadius;
  final double borderWidth;

  PinFieldTheme(
      {this.width = 56,
      this.height = 60,
      this.margin,
      this.padding,
      this.textStyle,
      this.fillColor,
      this.borderColor = const Color(0xFF000000),
      this.borderRadius = const BorderRadius.all(Radius.zero),
      this.borderWidth = 1});
}

class InternalPinField extends StatefulWidget {
  final int length;
  final bool? autoFocus;
  final bool? enabled;
  final bool? obscureText;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;
  final PinFieldTheme? pinTheme;

  const InternalPinField({
    super.key,
    required this.length,
    this.autoFocus = false,
    this.enabled = true,
    this.obscureText = false,
    this.onCompleted,
    this.onChanged,
    this.pinTheme,
  });

  @override
  State<InternalPinField> createState() => _InternalPinFieldState();
}

class _InternalPinFieldState extends State<InternalPinField> {
  late final SmsRetrieverImpl smsRetrieverImpl;
  late TextEditingController _controller;
  int length = 4;
  bool autoFocus = false;
  bool enabled = true;
  bool obscureText = false;

  late PinFieldTheme? defaultPinTheme;

  @override
  void initState() {
    _controller = TextEditingController();
    length = widget.length;
    autoFocus = widget.autoFocus ?? false;
    enabled = widget.enabled ?? true;
    defaultPinTheme = widget.pinTheme;
    obscureText = widget.obscureText ?? false;
    smsRetrieverImpl = SmsRetrieverImpl(SmartAuth());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    smsRetrieverImpl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: _controller,
      length: length,
      autofocus: autoFocus,
      enabled: enabled,
      defaultPinTheme: _toDefaultPinTheme(context),
      smsRetriever: smsRetrieverImpl,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      onCompleted: widget.onCompleted,
      onChanged: widget.onChanged,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      obscureText: obscureText,
    );
  }

  PinTheme _toDefaultPinTheme(BuildContext context) {
    if (defaultPinTheme == null) {
      return PinTheme(
        width: 56,
        height: 60,
        textStyle: const TextStyle(
          fontSize: 22,
          color: Color.fromRGBO(30, 60, 87, 1),
        ),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(222, 231, 240, .57),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.transparent),
        ),
      );
    }

    return PinTheme(
      width: defaultPinTheme!.width ?? 56,
      height: defaultPinTheme!.height ?? 60,
      margin: defaultPinTheme!.margin,
      padding: defaultPinTheme!.padding,
      textStyle: defaultPinTheme!.textStyle,
      decoration: BoxDecoration(
        color: defaultPinTheme!.fillColor,
        borderRadius: defaultPinTheme!.borderRadius.resolve(TextDirection.ltr),
        border: Border.all(
            color: defaultPinTheme!.borderColor,
            width: defaultPinTheme!.borderWidth,
            style: defaultPinTheme!.borderWidth == 0.0
                ? BorderStyle.none
                : BorderStyle.solid),
      ),
    );
  }
}
