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

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
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
        rangeThumbShape: RoundRangeSliderThumbShape(
          enabledThumbRadius: widget.thumbRadius,
          disabledThumbRadius: widget.thumbRadius,
        ),
        // overlayColor: widget.thumbColor.withOpacity(0.12),
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
        onChanged: (value) {
          setState(() {
            _currentValue = value;
          });
          widget.onChanged(value);
        },
        divisions: widget.divisions,
      ),
    );
  }
}
