import 'package:flutter/material.dart';

import 'button.props.dart';

class DUIButton extends StatefulWidget {
  final DUIButtonProps props;

  // TODO: GLobalKey is needed for different shapes, but that causes
  // interference with DUIButton.create function which is needed
  // to render from json.
  // final GlobalKey globalKey = GlobalKey();
  const DUIButton(this.props, {super.key}) : super();

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
  }

  // TODO: We may need to use Plain text here and not rich text.
  // Problem is we need we may need to change textColor in case of disabled state.
  // We would need to fetch a new textStyleClass for disabled state.
  // Not supporting it for now.
  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    return ElevatedButton(onPressed: () {}, child: child);

    // final styleClass = props.disabled == true
    //     ? props.styleClass?.copyWith(bgColor: props.disabledBackgroundColor)
    //     : props.styleClass;
    //
    // ButtonStyle style = ButtonStyle(overlayColor: MaterialStateProperty.resolveWith<Color?>(
    //       (states) => styleClass?.bgColor.let(toColor),
    // ),
    //     shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
    //       (states) => RoundedRectangleBorder(
    //         borderRadius:
    //             DUIDecoder.toBorderRadius(styleClass?.border?.borderRadius),
    //         side: toBorderSide(styleClass?.border),
    //       ),
    //     ),
    //     backgroundColor: MaterialStateProperty.resolveWith<Color?>(
    //       (states) => styleClass?.bgColor.let(toColor),
    //     ));
    //
    // return DUIContainer(
    //   styleClass: styleClass,
    //   child: ElevatedButton(
    //     onPressed: props.onClick.let((p0) {
    //       return () =>
    //           ActionHandler.instance.execute(context: context, actionFlow: p0);
    //     }),
    //     style: style,
    //     child: DUIText(props.text),
    //   ),
    // );
  }
}
