import 'dart:developer';

import 'package:digia_ui/Utils/util_functions.dart';
import 'package:flutter/material.dart';

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
      margin: getInsets(
        left: props.margin.left,
        right: props.margin.right,
        top: props.margin.top,
        bottom: props.margin.bottom,
      ),
      child: InkWell(
        onTap: () {
          log('Button Clicked');
        },
        child: Container(
          alignment: Alignment.center,
          width: props.width,
          padding: getInsets(
            left: props.margin.left,
            right: props.margin.right,
            top: props.margin.top,
            bottom: props.margin.bottom,
          ),
          height: props.height,
          decoration: BoxDecoration(
            color: props.disabled
                ? Color(int.parse('0xFF${props.disabledBackgroundColor}'))
                : Color(int.parse('0xFF${props.backgroundColor}')),
            borderRadius: props.cornerRadius.getCornerRadius(),
          ),
          child: Text(
            props.text,
            style: TextStyle(
              fontSize: props.fontSize ?? 14,
              color: props.disabled
                  ? Color(int.parse('0xFF${props.disabledTextColor}'))
                  : Color(int.parse('0xFF${props.textColor}')),
            ),
          ),
        ),
      ),
    );
  }
}
