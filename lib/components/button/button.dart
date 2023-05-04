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
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        width: props.width,
        padding: props.padding.margins(),
        margin: props.margin.margins(),
        height: props.height,
        decoration: BoxDecoration(
          color: props.disabled
              ? Color(int.parse('0xFF${props.disabledBackgroundColor}'))
              : Color(int.parse('0xFF${props.backgroundColor}')),
          borderRadius: props.cornerRadius.getRadius(),
        ),
        child: Text(
          props.text,
          style: TextStyle(
            color: props.disabled
                ? Color(int.parse('0xFF${props.disabledTextColor}'))
                : Color(int.parse('0xFF${props.textColor}')),
          ),
        ),
      ),
    );
  }
}
