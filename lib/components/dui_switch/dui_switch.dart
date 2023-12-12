import 'package:digia_ui/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/dui_switch/dui_switch_props.dart';
import 'package:flutter/material.dart';

class DUISwitch extends StatefulWidget {
  final DUISwitchProps props;
  final Function(bool value) onChange;
  const DUISwitch(this.props, {required  this.onChange, super.key});

  @override
  State<DUISwitch> createState() => _DUISwitchState();
}

class _DUISwitchState extends State<DUISwitch> {
  late bool _value;

  @override
  void initState() {
    _value = widget.props.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Switch.adaptive(
          value: _value,
          onChanged: (newval) {
            if (widget.props.enables == false) {
              return;
            }

            setState(() {
              _value = newval;
              widget.onChange(_value);
            });
          },
          activeColor: widget.props.activeColor?.let(toColor),
          inactiveThumbColor: widget.props.inactiveThumbColor?.let(toColor),
          activeTrackColor: widget.props.activeTrackColor?.let(toColor),
          inactiveTrackColor: widget.props.inactiveTrackColor?.let(toColor),
        ),
      ),
    );
  }
}
