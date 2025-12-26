import 'dart:async';
import 'package:flutter/material.dart';

class InternalSlider extends StatefulWidget {
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double thumbRadius;
  final double trackHeight;
  final int? divisions;

  const InternalSlider({
    super.key,
    this.min = 0.0,
    this.max = 100.0,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.thumbColor = Colors.white,
    this.thumbRadius = 10.0,
    this.trackHeight = 4.0,
    this.divisions,
  });

  @override
  State<InternalSlider> createState() => _InternalSliderState();
}

class _InternalSliderState extends State<InternalSlider> {
  late double _currentValue;
  Timer? _throttleTimer;
  double? _pendingValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void dispose() {
    _throttleTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(InternalSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync with parent only if the value has changed significantly
    // and differs from our local state (to avoid jitter)
    if (widget.value != oldWidget.value &&
        (widget.value - _currentValue).abs() > 0.01) {
      setState(() {
        _currentValue = widget.value;
      });
    }
  }

  void _handleChanged(double value) {
    // 1. Update UI Instantly
    setState(() {
      _currentValue = value;
    });

    // 2. Throttle Engine Calls (Max 30fps)
    _pendingValue = value;
    if (_throttleTimer == null || !_throttleTimer!.isActive) {
      widget.onChanged(value);
      _throttleTimer = Timer(const Duration(milliseconds: 32), () {
        if (_pendingValue != null) {
          widget.onChanged(_pendingValue!);
          _pendingValue = null;
        }
        _throttleTimer = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: widget.trackHeight,
        activeTrackColor: widget.activeColor,
        inactiveTrackColor: widget.inactiveColor,
        thumbColor: widget.thumbColor,
        disabledThumbColor: widget.thumbColor,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: widget.thumbRadius,
          disabledThumbRadius: widget.thumbRadius,
        ),
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: widget.thumbRadius,
        ),
        valueIndicatorColor: widget.activeColor,
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
        valueIndicatorShape: SliderComponentShape.noOverlay,
        showValueIndicator: ShowValueIndicator.never,
      ),
      child: Slider(
        min: widget.min,
        max: widget.max,
        value: _currentValue,
        onChanged: _handleChanged,
        divisions: widget.divisions,
      ),
    );
  }
}
