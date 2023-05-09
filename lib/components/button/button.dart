import 'dart:developer';

import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:flutter/material.dart';

import '../../Utils/color_extension.dart';
import 'button.props.dart';

class DUIButton extends StatefulWidget {
  final DUIButtonProps props;

  const DUIButton(this.props, {super.key}) : super();

  @override
  State<StatefulWidget> createState() => _DUIButtonState();
}

class _DUIButtonState extends State<DUIButton> {
  late DUIButtonProps props;
  _DUIButtonState();
  @override
  void initState() {
    super.initState();
    props = widget.props;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: props.margin?.margins(),
      child: InkWell(
        onTap: () {
          log('button clicked');
        },
        child: Container(
          alignment: Alignment.center,
          width: props.width ?? double.infinity,
          padding: props.padding?.margins() ?? EdgeInsets.zero,
          height: props.height ?? 150,
          decoration: BoxDecoration(
            color: props.disabled != null && props.disabled == true
                ? props.disabledBackgroundColor?.toColor()
                : props.backgroundColor?.toColor(),
            borderRadius: props.cornerRadius?.getRadius(),
          ),
          child: DUIText(props.text),
        ),
      ),
    );
  }
}
