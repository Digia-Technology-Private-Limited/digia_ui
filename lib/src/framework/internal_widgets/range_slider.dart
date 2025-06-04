import 'package:flutter/material.dart';

class InternalRangeSlider extends StatefulWidget {
  final double min;
  final double max;
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double thumbRadius;
  final double trackHeight;
  // final Axis orientation;
  // final bool showLabels;
  // final bool showValueIndicators;
  final int? divisions;

  const InternalRangeSlider({
    super.key,
    this.min = 0.0,
    this.max = 100.0,
    required this.values,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.thumbColor = Colors.white,
    this.thumbRadius = 10.0,
    this.trackHeight = 4.0,
    // this.orientation = Axis.horizontal,
    // this.showLabels = false,
    // this.showValueIndicators = false,
    this.divisions,
  });

  @override
  State<InternalRangeSlider> createState() => _InternalRangeSliderState();
}

class _InternalRangeSliderState extends State<InternalRangeSlider> {
  late RangeValues _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.values;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: widget.trackHeight,
        activeTrackColor: widget.activeColor,
        inactiveTrackColor: widget.inactiveColor,
        thumbColor: widget.thumbColor,
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
      child: RangeSlider(
        min: widget.min,
        max: widget.max,
        values: _currentValue,
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
