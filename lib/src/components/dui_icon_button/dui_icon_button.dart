import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/dui_icon_button/dui_icon_button_props.dart';
import 'package:digia_ui/src/components/dui_icons/dui_icon.dart';
import 'package:digia_ui/src/components/dui_icons/dui_icon_props.dart';
import 'package:digia_ui/src/core/page/dui_page_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/page/dui_page_bloc.dart';

class DUIIconButton extends StatefulWidget {
  final DUIIconButtonProps props;
  const DUIIconButton({required this.props, super.key});

  @override
  State<DUIIconButton> createState() => _DUIIconButtonState();
}

class _DUIIconButtonState extends State<DUIIconButton> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DUIPageBloc>();
    return IconButton(
      icon: DUIIcon(DUIIconProps.fromJson(widget.props.icon)),
      onPressed: () async {
        bloc.add(
            PostActionEvent(action: widget.props.onClick!, context: context));
      },
      padding: DUIDecoder.toEdgeInsets(widget.props.padding?.toJson()),
      alignment: DUIDecoder.toAlignment(widget.props.alignment),
      style: ButtonStyle(
        alignment: DUIDecoder.toAlignment(widget.props.childAlignment),
        backgroundColor: MaterialStateColor.resolveWith((states) =>
            widget.props.backgroundColor.letIfTrue(toColor) ??
            Colors.blueAccent),
        elevation: MaterialStatePropertyAll(widget.props.elevation),
      ),
    );
  }
}
