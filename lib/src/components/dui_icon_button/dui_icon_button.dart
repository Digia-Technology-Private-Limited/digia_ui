import 'package:digia_ui/src/components/dui_icon_button/dui_icon_button_props.dart';
import 'package:flutter/material.dart';

class DUIIconButton extends StatefulWidget {
  final DUIIconButtonProps props;
  const DUIIconButton({required this.props, super.key});

  @override
  State<DUIIconButton> createState() => _DUIIconButtonState();
}

class _DUIIconButtonState extends State<DUIIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){}, icon: const Icon(Icons.abc), );
  }
}