import 'package:digia_ui/src/components/DUIText/dui_text.dart';
import 'package:digia_ui/src/core/container/dui_container.dart';
import 'package:digia_ui/src/core/page/dui_page_bloc.dart';
import 'package:digia_ui/src/core/page/dui_page_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final bool _isLoading = false;
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
    final bloc = context.read<DUIPageBloc>();
    final styleclass = props.disabled == true
        ? props.styleClass?.copyWith(bgColor: props.disabledBackgroundColor)
        : props.styleClass;

    final childToRender = DUIContainer(
        styleClass: styleclass,
        child: _isLoading
            ? const SizedBox(
                width: 32, height: 32, child: CircularProgressIndicator())
            : DUIText(props.text));

    return props.onClick == null
        ? childToRender
        : GestureDetector(
            onTap: () async {
              bloc.add(
                  PostActionEvent(action: props.onClick!, context: context));
            },
            child: childToRender);
  }
}
