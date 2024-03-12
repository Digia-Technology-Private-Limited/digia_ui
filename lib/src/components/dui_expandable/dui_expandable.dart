import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/dui_expandable/dui_expandable_props.dart';
import 'package:digia_ui/src/components/dui_icons/icon_helpers/icon_data_serialization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' show pi;

class DUIExpandable extends StatefulWidget {
  final Map<String, List<DUIWidgetJsonData>> children;
  final DUIExpandableProps props;
  final DUIWidgetRegistry? registry;

  const DUIExpandable(
      {super.key, required this.children, this.registry, required this.props});

  @override
  State<DUIExpandable> createState() => _DUIExpandableState();
}

class _DUIExpandableState extends State<DUIExpandable> {
  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      key: UniqueKey(),
      header: DUIWidget(data: widget.children['header']!.first),
      collapsed: DUIWidget(
        data: widget.children['collapsedView']!.first,
      ),
      expanded: DUIWidget(
        data: widget.children['expandedView']!.first,
      ),
      controller:
          ExpandableController(initialExpanded: widget.props.initiallyExpanded),
      theme: ExpandableThemeData(
        bodyAlignment: (widget.props.bodyAlignment != null)
            ? getBodyAlignment(widget.props.bodyAlignment!)
            : null,
        headerAlignment: (widget.props.headerAlignment != null)
            ? getHeaderAlignment(widget.props.headerAlignment!)
            : null,
        iconPlacement: (widget.props.icon?.iconPlacement != null)
            ? getIconAlignment(widget.props.icon!.iconPlacement!)
            : null,
        // sizeCurve:,
        iconColor: widget.props.color?.letIfTrue(toColor),
        alignment: DUIDecoder.toAlignment(widget.props.alignment),
        animationDuration: Duration(
            milliseconds:
                NumDecoder.toInt(widget.props.animationDuration) ?? 1000),
        collapseIcon: (widget.props.icon?.collapseIcon != null)
            ? getIconData(icondataMap: widget.props.icon!.collapseIcon!)
            : CupertinoIcons.chevron_right,
        expandIcon: (widget.props.icon?.expandIcon != null)
            ? getIconData(icondataMap: widget.props.icon!.expandIcon!)
            : CupertinoIcons.square,
        hasIcon: widget.props.icon != null,
        iconPadding:
            DUIDecoder.toEdgeInsets(widget.props.icon?.iconPadding?.toJson()),
        iconSize: NumDecoder.toDouble(widget.props.icon?.iconSize),
        iconRotationAngle:
            ((widget.props.icon?.iconRotationAngle ?? 90.0) / 180) * pi,
        tapHeaderToExpand: widget.props.tapHeaderToExpand,
        tapBodyToExpand: widget.props.tapBodyToExpand,
        tapBodyToCollapse: widget.props.tapBodyToCollapse,
        useInkWell: widget.props.useInkWell,
        inkWellBorderRadius: BorderRadius.circular(
            NumDecoder.toDouble(widget.props.icon?.iconSize) ?? 0),
      ),
    );
  }

  ExpandablePanelBodyAlignment getBodyAlignment(String bodyAlignment) {
    switch (bodyAlignment) {
      case 'left':
      case 'LEFT':
      case 'Left':
        return ExpandablePanelBodyAlignment.left;
      case 'right':
      case 'RIGHT':
      case 'Right':
        return ExpandablePanelBodyAlignment.right;
      case 'center':
      case 'CENTER':
      case 'Center':
        return ExpandablePanelBodyAlignment.center;
      default:
        return ExpandablePanelBodyAlignment.left;
    }
  }

  ExpandablePanelIconPlacement getIconAlignment(String bodyAlignment) {
    switch (bodyAlignment) {
      case 'left':
      case 'LEFT':
      case 'Left':
        return ExpandablePanelIconPlacement.left;
      case 'right':
      case 'RIGHT':
      case 'Right':
        return ExpandablePanelIconPlacement.right;
      default:
        return ExpandablePanelIconPlacement.right;
    }
  }

  ExpandablePanelHeaderAlignment getHeaderAlignment(String bodyAlignment) {
    switch (bodyAlignment) {
      case 'top':
      case 'TOP':
      case 'Top':
        return ExpandablePanelHeaderAlignment.top;
      case 'bottom':
      case 'BOTTOM':
      case 'Bottom':
        return ExpandablePanelHeaderAlignment.bottom;
      case 'center':
      case 'CENTER':
      case 'Center':
        return ExpandablePanelHeaderAlignment.center;
      default:
        return ExpandablePanelHeaderAlignment.top;
    }
  }
}
