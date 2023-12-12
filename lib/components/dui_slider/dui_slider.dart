import 'package:digia_ui/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/dui_slider/dui_slider_props.dart';
import 'package:flutter/material.dart';

class DUISlider extends StatefulWidget {
  final DUISliderProps props;
  final Function(double value) onChanged;
  const DUISlider(this.props, {required this.onChanged, super.key});

  @override
  State<DUISlider> createState() => _DUISliderState();
}

class _DUISliderState extends State<DUISlider> {
  late double _value;

  @override
  void initState() {
    _value = widget.props.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Slider.adaptive(
          value: _value,
          onChanged: (double val) {
            if (widget.props.enables == false) {
              return;
            }
            setState(() {
              _value = val;
            });
          },
          min: widget.props.minVal,
          max: widget.props.maxVal,
          divisions: widget.props.divisions,
          activeColor: widget.props.activeColor?.let(toColor),
          inactiveColor: widget.props.inactiveColor?.let(toColor),
          thumbColor: widget.props.thumbColor?.let(toColor),
          secondaryActiveColor: Colors.black,
        ),
      ),
    );
  }
}
