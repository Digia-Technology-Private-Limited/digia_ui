import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/extensions.dart';
import 'package:digia_ui/src/components/dui_widget.dart';
import 'package:digia_ui/src/components/dui_wrap/dui_wrap_props.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIWrap extends StatefulWidget {
  final DUIWrapProps props;
  final List<DUIWidgetJsonData>? children;

  const DUIWrap({super.key, required this.props, this.children});

  @override
  State<DUIWrap> createState() => _DUIWrapState();
}

class _DUIWrapState extends State<DUIWrap> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: widget.props.spacing ?? 0,
      alignment: DUIDecoder.toWrapAlignment(widget.props.wrapAlignment),
      crossAxisAlignment:
          DUIDecoder.toWrapCrossAlignment(widget.props.wrapCrossAlignment),
      direction: DUIDecoder.toAxis(widget.props.direction),
      runSpacing: widget.props.runSpacing ?? 0,
      runAlignment: DUIDecoder.toWrapAlignment(widget.props.runAlignment),
      verticalDirection:
          DUIDecoder.toVerticalDirection(widget.props.verticalDirection),
      clipBehavior: DUIDecoder.toClip(widget.props.clipBehavior),
      children: !(widget.children.isNullOrEmpty)
          ? widget.children!.map((e) {
              return DUIWidget(data: e);
            }).toList()
          : [
              const Text(
                'Children field is Empty!',
                textAlign: TextAlign.center,
              ),
            ],
    );
  }
}
