import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
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
    final titleSpacing = props['titleSpacing'] as String?;
    final toolbarHeight = props['toolbarHeight'] as String?;

    return SliverAppBar(
      toolbarHeight: NumDecoder.toDouble(toolbarHeight) ?? 56,
      leadingWidth: 0,
      titleSpacing: NumDecoder.toDouble(titleSpacing) ?? 0,
      flexibleSpace: getFlexibleSpace(),
      backgroundColor: makeColor(backgroundColor),
      snap: NumDecoder.toBool(props['snap']) ?? false,
      pinned: NumDecoder.toBool(props['pinned']) ?? false,
      floating: NumDecoder.toBool(props['floating']) ?? false,
      collapsedHeight: collapsedHeight?.toHeight(context),
      expandedHeight: expandedHeight?.toHeight(context),
      title: getTitleWidget(),
      bottom: PreferredSize(
          preferredSize: Size(bottomPreferredWidth?.toWidth(context) ?? 0,
              bottomPreferredHeight?.toWidth(context) ?? 0),
          child: getBottomWidget()),
    );
  }

  Widget getLeadingWidget() {
    final leadingWidgetData = data.children['leading']?.firstOrNull;
    if (leadingWidgetData == null) {
      return const SizedBox.shrink();
    }

    final leadingWidget = DUIWidget(data: leadingWidgetData);
    return leadingWidget;
  }

  Widget getTitleWidget() {
    final titleWidgetData = data.children['title']?.firstOrNull;
    if (titleWidgetData == null) {
      return const SizedBox.shrink();
    }

    final titleWidget = DUIWidget(data: titleWidgetData);
    return titleWidget;
  }

  Widget getFlexibleSpace() {
    final flexibleSpaceWidgetData = data.children['flexibleSpace']?.firstOrNull;
    if (flexibleSpaceWidgetData == null) {
      return const SizedBox.shrink();
    }

    final flexibleSpaceWidget =
        FlexibleSpaceBar(background: DUIWidget(data: flexibleSpaceWidgetData));
    return flexibleSpaceWidget;
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
