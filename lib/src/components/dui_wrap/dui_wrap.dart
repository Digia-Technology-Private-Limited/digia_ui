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
      alignment: getWrapAlignment(widget.props.wrapAlignment ?? ''),
      crossAxisAlignment:
          getWrapCrossAlignment(widget.props.wrapCrossAlignment ?? ''),
      direction: getDirection(widget.props.direction ?? ''),
      runSpacing: widget.props.runSpacing ?? 0,
      runAlignment: getWrapAlignment(widget.props.runAlignment ?? ''),
      verticalDirection:
          getVerticalDirection(widget.props.verticalDirection ?? ''),
      children: widget.children!.map((e) {
        return DUIWidget(data: e);
      }).toList(),
    );
  }

  WrapAlignment getWrapAlignment(String wrapAlignment) {
    switch (wrapAlignment) {
      case 'start':
        return WrapAlignment.start;
      case 'center':
        return WrapAlignment.center;
      case 'spaceAround':
        return WrapAlignment.spaceAround;
      case 'spaceBetween':
        return WrapAlignment.spaceBetween;
      case 'spaceEvenly':
        return WrapAlignment.spaceEvenly;
      case 'end':
        return WrapAlignment.end;
      default:
        return WrapAlignment.start;
    }
  }

  WrapCrossAlignment getWrapCrossAlignment(String wrapAlignment) {
    switch (wrapAlignment) {
      case 'start':
        return WrapCrossAlignment.start;
      case 'center':
        return WrapCrossAlignment.center;
      case 'end':
        return WrapCrossAlignment.end;
      default:
        return WrapCrossAlignment.start;
    }
  }

  Axis getDirection(String direction) {
    switch (direction) {
      case 'vertical':
        return Axis.vertical;
      case 'horizontal':
        return Axis.horizontal;
      default:
        return Axis.vertical;
    }
  }

  VerticalDirection getVerticalDirection(String verticalDirection) {
    switch (verticalDirection) {
      case 'up':
        return VerticalDirection.up;
      case 'down':
        return VerticalDirection.down;
      default:
        return VerticalDirection.down;
    }
  }
}
