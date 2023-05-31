
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/core/action/action_handler.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:flutter/material.dart';

import 'button.props.dart';

class DUIButton extends StatefulWidget {
  final DUIButtonProps props;
  // TODO: GLobalKey is needed for different shapes, but that causes
  // interference with DUIButton.create function which is needed
  // to render from json.
  // final GlobalKey globalKey = GlobalKey();
  const DUIButton(this.props, {super.key}) : super();

  factory DUIButton.create(Map<String, dynamic> json) =>
      DUIButton(DUIButtonProps.fromJson(json));

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
    // TODO: Commented out for now. Check TODO near GlobalKey
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   renderbox =
    //       widget.globalKey.currentContext!.findRenderObject() as RenderBox;
    //   setState(() {
    //     width = renderbox.size.width;
    //     height = renderbox.size.height;
    //   });
    // });
  }

  // TODO: We may need to use Plain text here and not rich text.
  // Problem is we need we may need to change textColor in case of disabled state.
  // We would need to fetch a new textStyleClass for disabled state.
  // Not supporting it for now.
  @override
  Widget build(BuildContext context) {
    var styleclass = props.disabled == true
        ? props.styleClass?.copyWith(bgColor: props.disabledBackgroundColor)
        : props.styleClass;

    final widget =
        DUIContainer(styleClass: styleclass, child: DUIText(props.text));

    return props.onClick == null
        ? widget
        : InkWell(
            onTap: () {
              ActionHandler().executeAction(context, props.onClick!);
            },
            child: widget);
    // child: Container(
    //   width: props.width,
    //   height: props.height,
    //   alignment: toAlignmentGeometry(props.alignment),
    //   padding: toEdgeInsetsGeometry(props.padding),
    //   margin: toEdgeInsetsGeometry(props.margin),
    //   decoration: BoxDecoration(
    //     color: props.disabled == true
    //         ? toColor(props.disabledBackgroundColor ??
    //             DUIConfigConstants.fallbackBgColorHexCode)
    //         : toColor(props.backgroundColor ??
    //             DUIConfigConstants.fallbackBgColorHexCode),
    //     // borderRadius: BorderRadius.circular(props.shape == 'pill'
    //     //     ? width / 2
    //     //     : props.shape == 'rect'
    //     //         ? width / 100
    //     //         : 0),
    //   ),
    //   child: DUIText(props.text),
    // ),
  }
}
