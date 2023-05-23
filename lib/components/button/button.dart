import 'dart:developer';

import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:flutter/material.dart';

import 'button.props.dart';

class DUIButton extends StatefulWidget {
  final DUIButtonProps props;
  final GlobalKey globalKey = GlobalKey();
  DUIButton(this.props, GlobalKey globalKey, {super.key}) : super();

  @override
  State<StatefulWidget> createState() => _DUIButtonState();
}

class _DUIButtonState extends State<DUIButton> {
  late DUIButtonProps props;
  late RenderBox renderbox;
  double width = 0;
  double height = 0;
  _DUIButtonState();

  @override
  void initState() {
    super.initState();
    props = widget.props;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      renderbox =
          widget.globalKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        width = renderbox.size.width;
        height = renderbox.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log('button clicked');
      },
      child: Container(
        alignment: Alignment.center,
        width: props.width ?? double.infinity,
        padding: toEdgeInsetsGeometry(props.padding),
        height: props.height ?? 150,
        decoration: BoxDecoration(
          color: props.disabled != null && props.disabled == true
              ? toColor(props.disabledBackgroundColor ??
                  DUIConfigConstants.fallbackBgColorHexCode)
              : toColor(props.backgroundColor ??
                  DUIConfigConstants.fallbackBgColorHexCode),
          borderRadius: BorderRadius.circular(props.shape == 'pill'
              ? width / 2
              : props.shape == 'rect'
                  ? width / 100
                  : 0),
        ),
        child: DUIText(props.text),
      ),
    );
  }
}
