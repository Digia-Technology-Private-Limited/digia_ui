import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import '../../components/dui_icons/icon_helpers/icon_data_serialization.dart';
import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWExpandable extends VirtualStatelessWidget<Props> {
  VWExpandable({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    final header = childOf('header');
    final collapsed = childOf('collapsedView');
    final expanded = childOf('expandedView');
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
        bodyAlignment:
            To.expandablePanelBodyAlignment(props.getString('bodyAlignment')),
        headerAlignment: To.expandablePanelHeaderAlignment(
            props.getString('headerAlignment')),
        iconPlacement: To.expandablePanelIconPlacement(
            iconProps?.getString('iconPlacement')),
        iconColor: payload.evalColor(props.get('color')),
        alignment: To.alignment(props.get('alignment')),
        animationDuration:
            Duration(milliseconds: props.getInt('animationDuration') ?? 1000),
        collapseIcon: (iconProps?.getMap('collapseIcon') != null)
            ? getIconData(icondataMap: iconProps?.getMap('collapseIcon') ?? {})
            : CupertinoIcons.chevron_right,
        expandIcon: (iconProps?.getMap('expandIcon') != null)
            ? getIconData(icondataMap: iconProps?.getMap('expandIcon') ?? {})
            : CupertinoIcons.chevron_down,
        hasIcon: props.getBool('hasIcon') ?? true,
        iconPadding: To.edgeInsets(iconProps?.get('iconPadding')),
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
