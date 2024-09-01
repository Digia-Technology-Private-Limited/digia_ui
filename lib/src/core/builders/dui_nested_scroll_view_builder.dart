import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../json_widget_builder.dart';

class DUINestedScrollView extends DUIWidgetBuilder {
  DUINestedScrollView({required super.data});

  static DUINestedScrollView create(DUIWidgetJsonData data) {
    return DUINestedScrollView(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(headerSliverBuilder: (context, innerBoxIsScrolled) {
      return getHeaderWidget();
    }, body: Builder(builder: (context) {
      return CustomScrollView(
        slivers: getBodyWidget(),
      );
    }));
  }

  List<Widget> getHeaderWidget() {
    final headerWidgetData = data.children['headerWidget'];

    if (headerWidgetData == null) {
      return const [SliverToBoxAdapter(child: SizedBox.shrink())];
    }

    final headerWidget = headerWidgetData.map((e) {
      return DUIWidget(data: e);
    }).toList();
    return headerWidget;
  }

  List<Widget> getBodyWidget() {
    final bodyWidgetData = data.children['bodyWidget'];

    if (bodyWidgetData == null) {
      return const [SliverToBoxAdapter(child: SizedBox.shrink())];
    }

    final bodyWidget = bodyWidgetData.map((e) {
      return DUIWidget(data: e);
    }).toList();
    return bodyWidget;
  }
}
