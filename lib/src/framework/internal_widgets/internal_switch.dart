import 'package:flutter/material.dart';

class InternalSwitch extends StatefulWidget {
  final bool enabled;
  final bool? value;
  final Color? activeColor;
  final Color? inactiveThumbColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final void Function(bool)? onChanged;

  const InternalSwitch({
    super.key,
    required this.enabled,
    this.value,
    this.activeColor,
    this.inactiveThumbColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.onChanged,
  });

  @override
  State<InternalSwitch> createState() => _InternalSwitchState();
}

class _InternalSwitchState extends State<InternalSwitch> {
  bool _value = false;

  @override
  void initState() {
    _value = widget.value ?? false;
    super.initState();
  }

  void _setState(bool value) {
    setState(() {
      _value = value;
    });
    widget.onChanged?.call(value);
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
}
