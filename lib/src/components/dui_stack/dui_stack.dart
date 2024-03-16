import 'package:digia_ui/src/Utils/extensions.dart';
import 'package:digia_ui/src/components/dui_stack/dui_stack_props.dart';
import 'package:digia_ui/src/components/dui_widget.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIStack extends StatefulWidget {
  final DUIStackProps props;
  final List<DUIWidgetJsonData>? children;

  const DUIStack({super.key, required this.props, this.children});

  @override
  State<DUIStack> createState() => _DUIStackState();
}

class _DUIStackState extends State<DUIStack> {
  @override
  Widget build(BuildContext context) {
    List<Widget> positionedChild =widget.children!.map((e) {
      return Positioned(
        top: e.containerProps.valueFor(keyPath: 'positioned.top') ?? 0.0,
        bottom:
        e.containerProps.valueFor(keyPath: 'positioned.bottom') ?? 0.0,
        left: e.containerProps.valueFor(keyPath: 'positioned.left') ?? 0.0,
        right:
        e.containerProps.valueFor(keyPath: 'positioned.right') ?? 0.0,
        child: DUIWidget(
          data: e,
        ),
      );
    }).toList();
    return SizedBox(
      child: Stack(
          alignment: getChildAlignmentFit(widget.props.childAlignment ?? ''),
          fit: getStackFit(widget.props.fit ?? ''),
          children: widget.children!.map((e) {
            return e.containerProps.valueFor(keyPath: 'positioned.hasPosition') == 'none'?DUIWidget(data: e):Positioned(
              top: e.containerProps.valueFor(keyPath: 'positioned.top') ?? 0.0,
              bottom:
                  e.containerProps.valueFor(keyPath: 'positioned.bottom') ?? 0.0,
              left: e.containerProps.valueFor(keyPath: 'positioned.left') ?? 0.0,
              right:
                  e.containerProps.valueFor(keyPath: 'positioned.right') ?? 0.0,
              child: DUIWidget(
                data: e,
              ),
            );
          }).toList()),
    );
  }

  StackFit getStackFit(String fit) {
    switch (fit) {
      case 'expand':
        return StackFit.expand;
      case 'loose':
        return StackFit.loose;
      case 'passthrough':
        return StackFit.passthrough;
      default:
        return StackFit.loose;
    }
  }

  AlignmentGeometry getChildAlignmentFit(String fit) {
    switch (fit) {
      case 'center':
        return Alignment.center;
      case 'topLeft':
        return Alignment.topLeft;
      case 'topRight':
        return Alignment.topRight;
      case 'topCenter':
        return Alignment.topCenter;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'centerRight':
        return Alignment.centerRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'bottomRight':
        return Alignment.bottomRight;
      default:
        return Alignment.center;
    }
  }
}
