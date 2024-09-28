import 'package:flutter/material.dart';

import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import 'icon.dart';
import 'tab_view_item.dart';
import 'text.dart';

class VWTabView extends VirtualStatelessWidget<Props> {
  VWTabView({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    required super.repeatData,
  });

  bool get shouldRepeatChild => repeatData != null;

  late TabBarIndicatorSize _indicatorSize;

  TabBarIndicatorSize? _toTabBarIndicatorSize(dynamic value) => switch (value) {
        'tab' => TabBarIndicatorSize.tab,
        'label' => TabBarIndicatorSize.label,
        _ => null
      };

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();
    for (var child in children!) {
      if (child is! VWTabViewItem) {
        return empty();
        // throw Exception('All children of TabView must be of type TabViewItem');
      }
    }
    _indicatorSize = _toTabBarIndicatorSize(props.getString('indicatorSize')) ??
        TabBarIndicatorSize.tab;
    final tabs = List.castFrom(children!).map((child) {
      if (child is! VirtualStatelessWidget) return empty();
      final icon =
          VWIcon(props: child.props, commonProps: commonProps, parent: parent)
              .render(payload);
      final title =
          VWText(props: child.props, commonProps: commonProps, parent: parent)
              .render(payload);
      return Column(children: [icon, title]);
    });

    final initialIndex = payload.eval<int>(props.get('initialIndex')) ?? 0;
    final length = (children?.toWidgetArray(payload) ?? []).length;
    final hasTabs = props.getBool('hasTabs') ?? false;
    final labelPadding = To.edgeInsets(props.get('labelPadding'));
    final tabBarPadding = To.edgeInsets(props.get('tabBarPadding'));
    final unselectedLabelColor =
        payload.evalColor(props.get('unselectedLabelColor'));
    final unselectedLabelStyle =
        payload.getTextStyle(props.getMap('unselectedLabelStyle'));
    final indicatorColor = payload.evalColor(props.get('indicatorColor'));
    final labelStyle = payload.getTextStyle(props.getMap('selectedLabelStyle'));
    final dividerColor = payload.evalColor(props.get('dividerColor'));
    final labelColor = payload.evalColor(props.get('selectedLabelColor'));
    final dividerHeight = props.getDouble('dividerHeight');

    final viewportFraction = props.getDouble('viewportFraction') ?? 1.0;
    final scrollPhysics =
        To.scrollPhysics(props.getBool('isScrollable') ?? false);

    return Expanded(
      child: DefaultTabController(
        initialIndex: initialIndex,
        length: length,
        child: Column(
          children: [
            Visibility(
              visible: hasTabs,
              child: TabBar(
                indicatorSize: _indicatorSize,
                labelPadding: labelPadding,
                padding: tabBarPadding,
                unselectedLabelColor: unselectedLabelColor,
                unselectedLabelStyle: unselectedLabelStyle,
                indicatorColor: indicatorColor,
                labelStyle: labelStyle,
                dividerColor: dividerColor,
                labelColor: labelColor,
                dividerHeight: dividerHeight,
                tabs: tabs.toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                viewportFraction: viewportFraction,
                physics: scrollPhysics,
                children: children?.toWidgetArray(payload) ?? [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
