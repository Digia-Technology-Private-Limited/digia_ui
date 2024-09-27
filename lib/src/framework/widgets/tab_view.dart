import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
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
        throw Exception('All children of TabView must be of type TabViewItem');
      }
    }
    _indicatorSize = _toTabBarIndicatorSize(props.getString('indicatorSize')) ??
        TabBarIndicatorSize.tab;
    final tabBarPosition = props.getString('tabBarPosition') ?? 'top';
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
    return Expanded(
      child: DefaultTabController(
        initialIndex: payload.eval<int>(props.get('initialIndex')) ?? 0,
        length: (children?.toWidgetArray(payload) ?? []).length,
        child: Column(
          children: [
            if (tabBarPosition == 'top')
              Visibility(
                visible: props.getBool('hasTabs') ?? false,
                child: TabBar(
                  indicatorSize: _indicatorSize,
                  labelPadding:
                      DUIDecoder.toEdgeInsets(props.get('labelPadding')),
                  padding: DUIDecoder.toEdgeInsets(props.get('tabBarPadding')),
                  unselectedLabelColor:
                      makeColor(props.get('unselectedLabelColor')),
                  unselectedLabelStyle: toTextStyle(
                      DUITextStyle.fromJson(props.get('unselectedLabelStyle')),
                      payload.buildContext),
                  indicatorColor: makeColor(props.get('indicatorColor')),
                  labelStyle: toTextStyle(
                      DUITextStyle.fromJson(props.get('selectedLabelStyle')),
                      payload.buildContext),
                  dividerColor: makeColor(props.get('dividerColor')),
                  labelColor: makeColor(props.get('selectedLabelColor')),
                  dividerHeight: props.getDouble('dividerHeight'),
                  tabs: tabs.toList(),
                ),
              ),
            Expanded(
              child: TabBarView(
                viewportFraction: props.getDouble('viewportFraction') ?? 1.0,
                physics: props.getBool('isScrollable') ?? false
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                children: children?.toWidgetArray(payload) ?? [],
              ),
            ),
            if (tabBarPosition == 'bottom')
              Visibility(
                visible: props.getBool('hasTabs') ?? false,
                child: TabBar(
                  indicatorSize: _indicatorSize,
                  labelPadding:
                      DUIDecoder.toEdgeInsets(props.get('labelPadding')),
                  padding: DUIDecoder.toEdgeInsets(props.get('tabBarPadding')),
                  unselectedLabelColor:
                      makeColor(props.get('unselectedLabelColor')),
                  unselectedLabelStyle: toTextStyle(
                      DUITextStyle.fromJson(props.get('unselectedLabelStyle')),
                      payload.buildContext),
                  labelStyle: toTextStyle(
                      DUITextStyle.fromJson(props.get('selectedLabelStyle')),
                      payload.buildContext),
                  dividerColor: makeColor(props.get('dividerColor')),
                  labelColor: makeColor(props.get('selectedLabelColor')),
                  dividerHeight: props.getDouble('dividerHeight'),
                  indicatorColor: makeColor(props.get('indicatorColor')),
                  tabs: tabs.toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
