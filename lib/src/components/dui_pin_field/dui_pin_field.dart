import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../core/action/action_handler.dart';
import '../../core/action/action_prop.dart';
import '../../core/evaluator.dart';
import '../DUIText/dui_text_style.dart';
import '../dui_base_stateful_widget.dart';

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

class DUIPinField extends BaseStatefulWidget {
  final Map<String, dynamic> props;

  const DUIPinField({
    super.key,
    required super.varName,
    required this.props,
  });

  @override
  State<DUIPinField> createState() => _DUIPinFieldState();
}

class _DUIPinFieldState extends DUIWidgetState<DUIPinField> {
  late final SmsRetrieverImpl smsRetrieverImpl;
  late TextEditingController _controller;
  int length = 4;
  bool closeKeyboardWhenCompleted = true;
  bool autoFocus = false;
  bool enabled = true;

  Map<String, dynamic>? defaultPinTheme;

  @override
  void initState() {
    _controller = TextEditingController();
    length = eval<int>(widget.props['length'], context: context) ?? 4;
    closeKeyboardWhenCompleted = eval<bool>(
            widget.props['closeKeyboardWhenCompleted'],
            context: context) ??
        true;
    autoFocus =
        eval<bool>(widget.props['autoFocus'], context: context) ?? false;
    enabled = eval<bool>(widget.props['enabled'], context: context) ?? true;
    defaultPinTheme = widget.props['defaultPinTheme'];
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
      closeKeyboardWhenCompleted: closeKeyboardWhenCompleted,
      autofocus: autoFocus,
      enabled: enabled,
      defaultPinTheme: _toDefaultPinTheme(context),
      smsRetriever: smsRetrieverImpl,
      onCompleted: (value) async {
        final actionFlow = ActionFlow.fromJson(widget.props['onCompleted']);
        await ActionHandler.instance
            .execute(context: context, actionFlow: actionFlow);
      },
    );
  }

  @override
  Map<String, Function> getVariables() {
    return {
      'pin': () => _controller.text,
    };
  }

  PinTheme _toDefaultPinTheme(BuildContext context) {
    if (defaultPinTheme == null || defaultPinTheme?['fillColor'] == null) {
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

    double? width = eval<double>(defaultPinTheme?['width'], context: context);
    double? height = eval<double>(defaultPinTheme?['height'], context: context);
    EdgeInsets? margin = DUIDecoder.toEdgeInsets(defaultPinTheme?['margin']);
    EdgeInsets? padding = DUIDecoder.toEdgeInsets(defaultPinTheme?['padding']);
    TextStyle? textStyle = toTextStyle(
        DUITextStyle.fromJson(defaultPinTheme?['textStyle']), context);
    BoxDecoration? decoration;
    Color? fillColor = makeColor(defaultPinTheme?['fillColor']);
    Color borderColor =
        makeColor(defaultPinTheme?['borderColor']) ?? const Color(0xFF000000);
    BorderRadiusGeometry? borderRadius =
        DUIDecoder.toBorderRadius(defaultPinTheme?['borderRadius']);
    double borderWidth =
        eval<double>(defaultPinTheme?['borderWidth'], context: context) ?? 1;

    return PinTheme(
      width: width,
      height: height,
      margin: margin.resolve(TextDirection.ltr),
      padding: padding.resolve(TextDirection.ltr),
      textStyle: textStyle,
      decoration: decoration ??
          BoxDecoration(
            color: fillColor,
            borderRadius: borderRadius.resolve(TextDirection.ltr),
            border: Border.all(
                color: borderColor,
                width: borderWidth,
                style:
                    borderWidth == 0.0 ? BorderStyle.none : BorderStyle.solid),
          ),
    );
  }
}
