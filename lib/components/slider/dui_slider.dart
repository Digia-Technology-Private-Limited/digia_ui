import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/color_decoder.dart';
import 'dui_slider_props.dart';

class DUISlider extends StatefulWidget {
  final DUISliderProps props;
  const DUISlider(this.props, {super.key}) : super();

  @override
  State<DUISlider> createState() => _DUISliderState();
}

class _DUISliderState extends State<DUISlider> {
  late DUISliderProps props;
  late Color? activeColor;
  late double? value;
  late Color? inactiveColor;
  late double? max;
  late double? min;
  late int? divisions;
  late Color? thumbColor;

  @override
  void initState() {
    props = widget.props;
    value = props.value ?? 20;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // value = props.value ?? 20;
    final activeColor =
        ColorDecoder.fromHexString(props.activeColor ?? '#0000FF');
    final inactiveColor =
        ColorDecoder.fromHexString(props.inactiveColor ?? '#0000FF');
    final min = props.max;
    final max = props.min;
    final divisions = props.divisions;
    final thumbColor =
        ColorDecoder.fromHexString(props.thumbColor ?? '#0000FF');

    return Slider(
      value: value ?? 20,
      onChanged: (val) {
        setState(() {
          value = val;
        });
      },
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      max: max ?? 100,
      min: min ?? 0,
      divisions: divisions,
      thumbColor: thumbColor,
    );
  }
}
