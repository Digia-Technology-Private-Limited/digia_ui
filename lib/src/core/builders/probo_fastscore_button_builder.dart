import 'dart:async';

import 'package:flutter/material.dart';
import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
import '../../components/dui_base_stateful_widget.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import 'dui_text_builder.dart';

class ProboCustomComponentBuilder extends DUIWidgetBuilder {
  ProboCustomComponentBuilder(
      {required super.data, super.registry = DUIWidgetRegistry.shared});

  static ProboCustomComponentBuilder? create(DUIWidgetJsonData data) {
    return ProboCustomComponentBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return ProboCustomComponent(
      varName: data.varName,
      data: data,
      registry: registry,
    );
  }
}

class ProboCustomComponent extends BaseStatefulWidget {
  final DUIWidgetJsonData data;
  final DUIWidgetRegistry? registry;

  const ProboCustomComponent(
      {required super.varName, required this.data, this.registry, super.key});

  @override
  State<StatefulWidget> createState() => _ProboCustomComponentState();
}

class _ProboCustomComponentState extends DUIWidgetState<ProboCustomComponent> {
  late bool _isClicked;
  late Timer _timer1;
  late Timer _timer2;
  @override
  void initState() {
    _isClicked = true;
    _timer1 = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isClicked = false;
        });
      }
    });
    _timer2 = Timer(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _isClicked = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer1.cancel();
    _timer2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text =
        eval<String>(widget.data.props['buttonText']['text'], context: context);
    final style = toTextStyle(
        DUITextStyle.fromJson(widget.data.props['buttonText']['textStyle']),
        context);
    final textBuilder = DUITextBuilder.fromProps(
        props: widget.data.props['buttonText'] as Map<String, dynamic>?);
    Widget textWidget = textBuilder.build(context);
    final animationDuration =
        eval<int>(widget.data.props['animationDuration'], context: context);
    final height = eval<double>(widget.data.props['height'], context: context);
    final bgColor =
        eval<String>(widget.data.props['bgColor'], context: context);
    final borderRadius =
        DUIDecoder.toBorderRadius(widget.data.props['borderRadius']);
    final textWidth = _calculateTextWidth(
        text,
        style ??
            const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal));

    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _isClicked = !_isClicked;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: animationDuration ?? 300),
          height: height,
          width: _isClicked ? 0 : (textWidth + 4),
          decoration: BoxDecoration(
              borderRadius: borderRadius, color: makeColor(bgColor)),
          child: Center(child: textWidget),
        ),
      );
    });
  }

  @override
  Map<String, Function> getVariables() {
    return {'': () => {}};
  }

  double _calculateTextWidth(String? text, TextStyle style) {
    final textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr);
    textPainter.layout();
    return textPainter.size.width;
  }
}
