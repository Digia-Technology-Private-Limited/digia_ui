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

  const DUIExpandable({super.key, required this.children, this.registry, required this.props});

  @override
  State<DUIExpandable> createState() => _DUIExpandableState();
}

class _DUIExpandableState extends State<DUIExpandable> {
  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      key: UniqueKey(),
      header: (widget.children['header']?.firstOrNull).let((p0) => DUIWidget(data: p0)),
      collapsed: DUIWidget(
        data: widget.children['collapsedView']!.first,
      ),
      expanded: DUIWidget(
        data: widget.children['expandedView']!.first,
      ),
      controller: ExpandableController(initialExpanded: widget.props.initiallyExpanded),
      theme: ExpandableThemeData(
        bodyAlignment: _toExpandablePanelBodyAlignment(widget.props.bodyAlignment),
        headerAlignment: _toExpandablePanelHeaderAlignment(widget.props.headerAlignment),
        iconPlacement: _toExpandablePanelIconPlacement(widget.props.icon?.iconPlacement),
        // sizeCurve:,
        iconColor: widget.props.color?.letIfTrue(toColor),
        alignment: DUIDecoder.toAlignment(widget.props.alignment),
        animationDuration: Duration(milliseconds: NumDecoder.toInt(widget.props.animationDuration) ?? 1000),
        collapseIcon: (widget.props.icon?.collapseIcon != null)
            ? getIconData(icondataMap: widget.props.icon!.collapseIcon!)
            : CupertinoIcons.chevron_right,
        expandIcon: (widget.props.icon?.expandIcon != null)
            ? getIconData(icondataMap: widget.props.icon!.expandIcon!)
            : CupertinoIcons.chevron_down,
        hasIcon: widget.props.icon != null,
        iconPadding: DUIDecoder.toEdgeInsets(widget.props.icon?.iconPadding?.toJson()),
        iconSize: NumDecoder.toDouble(widget.props.icon?.iconSize),
        iconRotationAngle: ((widget.props.icon?.iconRotationAngle ?? 90.0) / 180) * pi,
        tapHeaderToExpand: widget.props.tapHeaderToExpand,
        tapBodyToExpand: widget.props.tapBodyToExpand,
        tapBodyToCollapse: widget.props.tapBodyToCollapse,
        useInkWell: widget.props.useInkWell,
        inkWellBorderRadius: BorderRadius.circular(NumDecoder.toDouble(widget.props.icon?.iconSize) ?? 0),
      ),
    );
  }

  ExpandablePanelBodyAlignment? _toExpandablePanelBodyAlignment(String? bodyAlignment) {
    if (bodyAlignment == null) return null;

    switch (bodyAlignment.toLowerCase()) {
      case 'left':
        return ExpandablePanelBodyAlignment.left;
      case 'right':
        return ExpandablePanelBodyAlignment.right;
      case 'center':
        return ExpandablePanelBodyAlignment.center;
      default:
        return ExpandablePanelBodyAlignment.left;
    }
  }

  ExpandablePanelIconPlacement? _toExpandablePanelIconPlacement(String? alignment) {
    if (alignment == null) return null;

    switch (alignment) {
      case 'left':
        return ExpandablePanelIconPlacement.left;
      case 'right':
        return ExpandablePanelIconPlacement.right;
      default:
        return ExpandablePanelIconPlacement.right;
    }
  }

  ExpandablePanelHeaderAlignment? _toExpandablePanelHeaderAlignment(String? alignment) {
    if (alignment == null) return null;

    switch (alignment.toLowerCase()) {
      case 'top':
        return ExpandablePanelHeaderAlignment.top;
      case 'bottom':
        return ExpandablePanelHeaderAlignment.bottom;
      case 'center':
        return ExpandablePanelHeaderAlignment.center;
      default:
        return ExpandablePanelHeaderAlignment.top;
    }
  }
}
