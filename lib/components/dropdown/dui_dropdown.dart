import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/components/dropdown/dui_dropdown_props.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/color_decoder.dart';

class DUIDropdown extends StatefulWidget {
  final DUIDropdownProps props;
  const DUIDropdown(this.props, {super.key});

  @override
  State<DUIDropdown> createState() => _DUIDropdownState();
}

class _DUIDropdownState extends State<DUIDropdown> {
  late DUIDropdownProps props;
  late BorderRadius? borderRadius;
  late String? alignment;
  late Color? dropdownColor;
  late Color? focusColor;
  late String value;

  @override
  void initState() {
    props = widget.props;
    value = props.dropLabelValue![0]['dropValue'].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = DUIDecoder.toBorderRadius(props.borderRadius ?? 20);
    final alignment =
        DUIDecoder.toAlignment(props.alignment ?? 'center') ?? Alignment.center;
    final dropdownColor =
        ColorDecoder.fromHexString(props.dropdownColor ?? '#FFFFFF');
    final focusColor =
        ColorDecoder.fromHexString(props.focusColor ?? '#FFFFFF');

    return DropdownButton(
      value: value,
      items: List.generate(
          props.dropLabelValue!.length,
          (index) => DropdownMenuItem(
                value: props.dropLabelValue![index]['dropValue'].toString(),
                child:
                    Text(props.dropLabelValue![index]['dropLabel'].toString()),
              )),
      onChanged: (val) {
        setState(() {
          value = val ?? '';
        });
      },
      borderRadius: borderRadius,
      alignment: alignment,
      dropdownColor: dropdownColor,
      focusColor: focusColor,
      isExpanded: props.isExpanded ?? false,
    );
  }
}
