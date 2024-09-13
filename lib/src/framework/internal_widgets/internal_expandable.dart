import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../components/dui_icons/icon_helpers/icon_data_serialization.dart';
import '../render_payload.dart';

class InternalExpandable extends StatefulWidget {
  final Widget header;
  final Widget collapsed;
  final Widget expanded;
  final Map<String, dynamic> props;
  final RenderPayload payload;

  const InternalExpandable({
    super.key,
    required this.header,
    required this.collapsed,
    required this.expanded,
    required this.props,
    required this.payload,
  });

  @override
  State<InternalExpandable> createState() => _InternalExpandableState();
}

class _InternalExpandableState extends State<InternalExpandable> {
  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      key: UniqueKey(),
      header: widget.header,
      collapsed: widget.collapsed,
      expanded: widget.expanded,
      controller: ExpandableController(
        initialExpanded:
            widget.payload.eval<bool>(widget.props['initiallyExpanded']),
      ),
      theme: ExpandableThemeData(
        bodyAlignment: DUIDecoder.toExpandablePanelBodyAlignment(
          widget.payload.eval<String>(widget.props['bodyAlignment']),
        ),
        headerAlignment: DUIDecoder.toExpandablePanelHeaderAlignment(
          widget.payload.eval<String>(widget.props['headerAlignment']),
        ),
        iconPlacement: DUIDecoder.toExpandablePanelIconPlacement(
          widget.payload.eval<String>(widget.props['icon']?['iconPlacement']),
        ),
        iconColor:
            makeColor(widget.payload.eval<String>(widget.props['color'])),
        alignment: DUIDecoder.toAlignment(
            widget.payload.eval<String>(widget.props['alignment'])),
        animationDuration: Duration(
          milliseconds:
              widget.payload.eval<int>(widget.props['animationDuration']) ??
                  1000,
        ),
        collapseIcon: _getIcon(widget.props['icon']?['collapseIcon'],
            CupertinoIcons.chevron_right),
        expandIcon: _getIcon(
            widget.props['icon']?['expandIcon'], CupertinoIcons.chevron_down),
        hasIcon: widget.props['icon'] != null,
        iconPadding:
            DUIDecoder.toEdgeInsets(widget.props['icon']?['iconPadding']),
        iconSize:
            widget.payload.eval<double>(widget.props['icon']?['iconSize']),
        iconRotationAngle: ((widget.payload.eval<double>(
                        widget.props['icon']?['iconRotationAngle']) ??
                    90.0) /
                180) *
            pi,
        tapHeaderToExpand:
            widget.payload.eval<bool>(widget.props['tapHeaderToExpand']),
        tapBodyToExpand:
            widget.payload.eval<bool>(widget.props['tapBodyToExpand']),
        tapBodyToCollapse:
            widget.payload.eval<bool>(widget.props['tapBodyToCollapse']),
        useInkWell: widget.payload.eval<bool>(widget.props['useInkWell']),
        inkWellBorderRadius: BorderRadius.circular(
          widget.payload.eval<double>(widget.props['inkWellBorderRadius']) ?? 0,
        ),
      ),
    );
  }

  IconData? _getIcon(Map<String, dynamic>? iconData, IconData defaultIcon) {
    return (iconData != null)
        ? getIconData(icondataMap: iconData)
        : defaultIcon;
  }
}
