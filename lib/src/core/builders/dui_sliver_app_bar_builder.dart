import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../json_widget_builder.dart';

class DUISliverAppBarBuilder extends DUIWidgetBuilder {
  DUISliverAppBarBuilder({required super.data});

  static DUISliverAppBarBuilder create(DUIWidgetJsonData data) {
    return DUISliverAppBarBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final props = data.props;
    final bottomPreferredWidth = props['bottomPreferredWidth'] as String?;
    final bottomPreferredHeight = props['bottomPreferredHeight'] as String?;
    final collapsedHeight = props['collapsedHeight'] as String?;
    final expandedHeight = props['expandedHeight'] as String?;
    final backgroundColor = props['backgroundColor'] as String?;

    return SliverAppBar(
      backgroundColor: makeColor(backgroundColor),
      snap: props['snap'] ?? false,
      pinned: props['pinned'] ?? false,
      floating: props['floating'] ?? false,
      collapsedHeight: collapsedHeight?.toHeight(context),
      expandedHeight: expandedHeight?.toHeight(context),
      title: getTitleWidget(),
      bottom: PreferredSize(
          preferredSize: Size(bottomPreferredWidth?.toWidth(context) ?? 0,
              bottomPreferredHeight?.toWidth(context) ?? 0),
          child: getBottomWidget()),
    );
  }

  Widget getTitleWidget() {
    final titleWidgetData = data.children['title']?.firstOrNull;
    if (titleWidgetData == null) {
      return const SizedBox.shrink();
    }

    final titleWidget = DUIWidget(data: titleWidgetData);
    return titleWidget;
  }

  Widget getBottomWidget() {
    final bottomWidgetData = data.children['bottom']?.firstOrNull;
    if (bottomWidgetData == null) {
      return const SizedBox.shrink();
    }

    final bottomWidget = DUIWidget(data: bottomWidgetData);
    return bottomWidget;
  }
}
