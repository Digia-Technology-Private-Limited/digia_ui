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

  @override
  void initState() {
    super.initState();
    value = false;
    props = widget.props;
  }

  @override
  Widget build(BuildContext context) {
    return GFCheckbox(
      onChanged: (val) {
        setState(() {
          value = val;
        });
      },
      value: value,
      activeBgColor: Colors.deepPurpleAccent,
      size: 24,
    );
  }
}
