import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../components/dui_icons/icon_helpers/icon_data_serialization.dart';
import '../core/virtual_stateless_widget.dart';
import '../render_payload.dart';

class VWExpandable extends VirtualStatelessWidget {
  VWExpandable({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    required super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    final header = childOf('header');
    final collapsed = childOf('collapsed');
    final expanded = childOf('expanded');
    if (header == null || collapsed == null || expanded == null) return empty();
    final iconProps = props.toProps('icon');

    return ExpandablePanel(
      key: UniqueKey(),
      header: header.toWidget(payload),
      collapsed: collapsed.toWidget(payload),
      expanded: expanded.toWidget(payload),
      controller: ExpandableController(
        initialExpanded: props.getBool('initiallyExpanded'),
      ),
      theme: ExpandableThemeData(
        bodyAlignment: DUIDecoder.toExpandablePanelBodyAlignment(
            props.getString('bodyAlignment')),
        headerAlignment: DUIDecoder.toExpandablePanelHeaderAlignment(
            props.getString('headerAlignment')),
        iconPlacement: DUIDecoder.toExpandablePanelIconPlacement(
            iconProps?.getString('iconPlacement')),
        iconColor: makeColor(props.get('color')),
        alignment: DUIDecoder.toAlignment(props.getString('alignment')),
        animationDuration:
            Duration(milliseconds: props.getInt('animationDuration') ?? 1000),
        collapseIcon: (iconProps?.getMap('collapseIcon') != null)
            ? getIconData(icondataMap: iconProps?.getMap('collapseIcon') ?? {})
            : CupertinoIcons.chevron_right,
        expandIcon: (iconProps?.getMap('expandIcon') != null)
            ? getIconData(icondataMap: iconProps?.getMap('expandIcon') ?? {})
            : CupertinoIcons.chevron_down,
        hasIcon: props.getBool('hasIcon') ?? true,
        iconPadding: DUIDecoder.toEdgeInsets(iconProps?.getMap('iconPadding')),
        iconSize: iconProps?.getDouble('size'),
        iconRotationAngle:
            ((iconProps?.getDouble('iconRotationAngle') ?? 90.0) / 180) * pi,
        tapHeaderToExpand: props.getBool('tapHeaderToExpand') ?? true,
        tapBodyToExpand: props.getBool('tapBodyToExpand') ?? false,
        tapBodyToCollapse: props.getBool('tapBodyToCollapse') ?? false,
        useInkWell: props.getBool('useInkWell') ?? false,
        inkWellBorderRadius:
            BorderRadius.circular(iconProps?.getDouble('size') ?? 0),
      ),
    );
  }
}
