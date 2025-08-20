import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this._smartAuth);

  final SmartAuth _smartAuth;

  @override
  Future<void> dispose() => _smartAuth.removeUserConsentApiListener();

  @override
  Future<String?> getSmsCode() async {
    final res = await _smartAuth.getSmsWithUserConsentApi();
    return res.hasData ? res.data?.code : null;
  }

  @override
  bool get listenForMultipleSms => false;
}

class PinField extends StatefulWidget {
  const PinField({
    super.key,
    required this.length,
    this.autoFocus = false,
    this.enabled = true,
    this.obscureText = false,
    this.onCompleted,
    this.onChanged,
    this.pinTheme,
    this.inputFormatters = const [],
  });

  final int length;
  final bool autoFocus;
  final bool enabled;
  final bool obscureText;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final PinTheme? pinTheme;
  final List<TextInputFormatter> inputFormatters;

  @override
  State<PinField> createState() => _PinFieldState();
}

class _PinFieldState extends State<PinField> {
  late final TextEditingController _controller;
  late final SmsRetrieverImpl _smsRetrieverImpl;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _smsRetrieverImpl = SmsRetrieverImpl(SmartAuth.instance);
  }

  @override
  void dispose() {
    _controller.dispose();
    _smsRetrieverImpl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: _controller,
      length: widget.length,
      autofocus: widget.autoFocus,
      enabled: widget.enabled,
      defaultPinTheme: widget.pinTheme,
      smsRetriever: _smsRetrieverImpl,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      onCompleted: widget.onCompleted,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      obscureText: widget.obscureText,
    );
  }
}
