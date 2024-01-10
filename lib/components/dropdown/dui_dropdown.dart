import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/components/dropdown/dui_dropdown_props.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../Utils/basic_shared_utils/color_decoder.dart';

class DUIDropdown extends StatefulWidget {
  final DUIDropdownProps props;
  const DUIDropdown(this.props, {super.key});

  @override
  State<DUIDropdown> createState() => _DUIDropdownState();
}

class _DUIDropdownState extends State<DUIDropdown> {
  late DUIDropdownProps props;
  late double borderRadius;
  late Alignment? alignment;
  late Color? dropdownColor;
  late Color? focusColor;
  late String value;
  late String label;
  late List<Map>? items;

  @override
  void initState() {
    props = widget.props;
    value = 'Item 1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = props.items;
    final borderRadius = DUIDecoder.toBorderRadius(props.borderRadius);
    final alignment = DUIDecoder.toAlignment(props.alignment);
    final dropdownColor =
        ColorDecoder.fromHexString(props.dropdownColor ?? '#FFFFFF');
    final focusColor =
        ColorDecoder.fromHexString(props.focusColor ?? '#FFFFFF');

    // return DropdownButton(
    //   value: value,
    //   items: const [
    //     DropdownMenuItem(value: 'Item 1', child: Text('Item 1')),
    //     DropdownMenuItem(
    //       value: 'Item 2',
    //       child: Text('Item 2'),
    //     ),
    //     DropdownMenuItem(
    //       value: 'Item 3',
    //       child: Text('Item 3'),
    //     )
    //   ],
    //   onChanged: (val) {
    //     setState(() {
    //       value = val.toString();
    //     });
    //   },
    //   borderRadius: borderRadius,
    //   alignment: alignment ?? Alignment.center,
    //   dropdownColor: dropdownColor,
    //   focusColor: focusColor,
    //   isExpanded: props.isExpanded ?? false,
    // );

    return DropdownButton2(
      items: List.generate(items.length,
          (index) => DropdownMenuItem(child: Text(items[index]['label']))),
      onChanged: (val) {
        value = val.toString();
      },
      alignment: alignment ?? Alignment.center,
      dropdownStyleData: DropdownStyleData(
        decoration:
            BoxDecoration(color: dropdownColor, borderRadius: borderRadius),
      ),
      isExpanded: props.isExpanded ?? false,
    );
  }
}
