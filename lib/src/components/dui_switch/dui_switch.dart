import 'package:flutter/material.dart';

import '../dui_base_stateful_widget.dart';

class DUISwitch extends BaseStatefulWidget {
  final String? name;
  final bool enabled;
  final bool? value;
  final Color? activeColor;
  final Color? inactiveThumbColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;

  const DUISwitch(
      {super.key,
      this.name,
      required this.enabled,
      this.value,
      this.activeColor,
      this.inactiveThumbColor,
      this.activeTrackColor,
      this.inactiveTrackColor});

  @override
  State<DUISwitch> createState() => _DUISwitchState();
}

class _DUISwitchState extends DUIWidgetState<DUISwitch> {
  bool _value = false;

  @override
  void initState() {
    _value = widget.value ?? false;
    super.initState();
  }

  _setState(bool value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final onChange = widget.enabled ? _setState : null;

    return Switch.adaptive(
      value: _value,
      onChanged: onChange,
      activeColor: widget.activeColor,
      inactiveThumbColor: widget.inactiveThumbColor,
      activeTrackColor: widget.activeTrackColor,
      inactiveTrackColor: widget.inactiveTrackColor,
    );
  }

  @override
  Map<String, Function> getVariables() {
    return {'value': () => _value, 'enabled': () => widget.enabled};
  }

  @override
  String? get name => widget.name;
}
