import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/dui_expandable/dui_expandable_props.dart';
import 'package:digia_ui/src/components/dui_icons/icon_helpers/icon_data_serialization.dart';
import 'package:digia_ui/src/core/builders/dui_json_widget_builder.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';

class DUIExpandable extends StatefulWidget {
  final DUIExpandableProps props;
  final DUIWidgetRegistry? registry;

  const DUIExpandable({super.key, required this.props, this.registry});

  @override
  State<DUIExpandable> createState() => _DUIExpandableState();
}

class _DUIExpandableState extends State<DUIExpandable> {
  @override
  Widget build(BuildContext context) {
    return Expandable(
      collapsed: (widget.props.collapsed != null)
          ? DUIJsonWidgetBuilder(
                  data: DUIWidgetJsonData.fromJson(widget.props.collapsed!),
                  registry: widget.registry!)
              .build(context)
          : Container(),
      expanded: (widget.props.expanded != null)
          ? DUIJsonWidgetBuilder(
                  data: DUIWidgetJsonData.fromJson(widget.props.expanded!),
                  registry: widget.registry!)
              .build(context)
          : Container(),
      theme: ExpandableThemeData(
        bodyAlignment: (widget.props.bodyAlignment != null)
            ? getBodyAlignment(widget.props.bodyAlignment!)
            : null,
        headerAlignment: (widget.props.headerAlignment != null)
            ? getHeaderAlignment(widget.props.headerAlignment!)
            : null,
        iconPlacement: (widget.props.iconPlacement != null)
            ? getIconAlignment(widget.props.iconPlacement!)
            : null,
        // sizeCurve:,
        iconColor: widget.props.color?.letIfTrue(toColor),
        alignment: DUIDecoder.toAlignment(widget.props.alignment),
        animationDuration:
            Duration(milliseconds: widget.props.animationDuration ?? 1000),
        collapseIcon: (widget.props.collapseIcon != null)
            ? getIconData(icondataMap: widget.props.collapseIcon!)
            : CupertinoIcons.chevron_right,
        expandIcon: (widget.props.collapseIcon != null)
            ? getIconData(icondataMap: widget.props.collapseIcon!)
            : CupertinoIcons.chevron_down,
        hasIcon: widget.props.hasIcon,
        iconPadding: DUIDecoder.toEdgeInsets(widget.props.padding?.toJson()),
        iconSize: widget.props.iconSize,
        iconRotationAngle: widget.props.iconSize,
        tapHeaderToExpand: widget.props.tapHeaderToExpand,
        tapBodyToExpand: widget.props.tapBodyToExpand,
        tapBodyToCollapse: widget.props.tapBodyToCollapse,
        useInkWell: widget.props.useInkWell,
        inkWellBorderRadius: DUIDecoder.toBorderRadius(
            widget.props.inkWellBorderRadius?.borderRadius),
      ),
      controller: ExpandableController(initialExpanded: true),
      key: UniqueKey(),
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
