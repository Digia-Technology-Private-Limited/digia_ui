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
      margin: toEdgeInsetsGeometry(props.margin),
      child: InkWell(
        onTap: () {
          log('Button Clicked');
        },
        child: Container(
          alignment: Alignment.center,
          width: props.width,
          padding: toEdgeInsetsGeometry(props.padding),
          height: props.height,
          decoration: BoxDecoration(
            color: props.disabled
                ? toColor(props.disabledBackgroundColor)
                : toColor(props.backgroundColor),
            borderRadius: toBorderRadiusGeometry(props.cornerRadius),
          ),
          child: Text(
            props.text,
            style: TextStyle(
                fontSize: props.fontSize ?? 14,
                color: props.disabled
                    ? toColor(props.disabledTextColor)
                    : toColor(props.textColor)),
          ),
        ),
      ),
    );
  }
}
