import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import 'dui_switch_props.dart';

class DUISwitch extends StatefulWidget {
  final DUISwitchProps props;
  const DUISwitch(this.props, {super.key});

  @override
  State<DUISwitch> createState() => _DUISwitchState();
}

class _DUISwitchState extends State<DUISwitch> {
  bool _value = false;

  @override
  void initState() {
    _value = widget.props.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final onChange = widget.props.enabled.letIfTrue((p0) => (value) {
          setState(() {
            _value = value;
          });
        });

    return Switch.adaptive(
      value: _value,
      onChanged: onChange,
      activeColor: widget.props.activeColor.let(toColor),
      inactiveThumbColor: widget.props.inactiveThumbColor.let(toColor),
      activeTrackColor: widget.props.activeTrackColor.let(toColor),
      inactiveTrackColor: widget.props.inactiveTrackColor.let(toColor),
    );
  }
}
