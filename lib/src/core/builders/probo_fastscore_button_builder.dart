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
import 'dui_image_builder.dart';
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
    final bgColor =
        eval<String>(widget.data.props['bgColor'], context: context);
    final borderRadius =
        DUIDecoder.toBorderRadius(widget.data.props['borderRadius']);
    final imageSrc =
        eval<String>(widget.data.props['imageSrc'], context: context) ?? '';
    final textWidth = _calculateTextWidth(text,
        style ?? const TextStyle(fontSize: 8.0, fontWeight: FontWeight.w400));

    final textHeight = _calculateTextHeight(text,
        style ?? const TextStyle(fontSize: 8.0, fontWeight: FontWeight.w400));

    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _isClicked = true;
          });
        },
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(vertical: 1),
          duration: Duration(milliseconds: animationDuration ?? 300),
          height: textHeight + 2,
          width: _isClicked ? 16 : ((textWidth) + 12 + 2 + 2 + 1 + 3),
          decoration: BoxDecoration(
              borderRadius: borderRadius, color: makeColor(bgColor)),
          child: Center(
              child: Row(
            children: [
              const SizedBox(
                width: 2,
              ),
              SizedBox(
                height: 12,
                width: 12,
                child: DUIImageBuilder.fromProps(props: {
                  'imageSrc': imageSrc,
                  'fit': widget.data.props['imageFit']
                }).build(context),
              ),
              const SizedBox(
                width: 2,
              ),
              AnimatedContainer(
                  padding: const EdgeInsets.only(left: 1, right: 3),
                  duration: Duration(milliseconds: animationDuration ?? 300),
                  width: _isClicked ? 0 : textWidth + 4,
                  child: textWidget),
            ],
          )),
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
    return textPainter.size.width * 1.08;
  }

  double _calculateTextHeight(String? text, TextStyle style) {
    final textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr);
    textPainter.layout();
    return textPainter.size.height;
  }
}
