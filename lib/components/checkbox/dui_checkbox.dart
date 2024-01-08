import 'package:digia_ui/Utils/basic_shared_utils/color_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/components/checkbox/dui_checkbox_props.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/checkbox/gf_checkbox.dart';

class DUICheckbox extends StatefulWidget {
  final DUICheckboxProps props;

  const DUICheckbox(this.props, {super.key}) : super();

  @override
  State<DUICheckbox> createState() => _DUICheckboxState();
}

class _DUICheckboxState extends State<DUICheckbox> {
  late DUICheckboxProps props;
  late bool value;
  late Color? activeColor;
  late double? size;

  @override
  void initState() {
    props = widget.props;
    value = props.value ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor =
        ColorDecoder.fromHexString(props.activeBgColor ?? '#0000FF');
    final size = NumDecoder.toDouble(props.size) ?? 24;
    return GFCheckbox(
      onChanged: (val) {
        setState(() {
          value = val;
        });
      },
      value: value,
      activeBgColor: activeColor,
      size: size,
    );
  }
}
