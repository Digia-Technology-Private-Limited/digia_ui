import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../components/dui_base_stateful_widget.dart';
import '../bracket_scope_provider.dart';
import '../json_widget_builder.dart';
import 'dui_json_widget_builder.dart';

class DUINestedScrollViewBuilder extends DUIWidgetBuilder {
  DUINestedScrollViewBuilder({required super.data});

  static DUINestedScrollViewBuilder create(DUIWidgetJsonData data) {
    return DUINestedScrollViewBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUINestedScrollView(
      data: data,
      varName: data.varName,
      registry: registry,
    );
  }
}

class DUINestedScrollView extends BaseStatefulWidget {
  final DUIWidgetJsonData data;
  final DUIWidgetRegistry? registry;
  const DUINestedScrollView(
      {required this.data, super.key, required super.varName, this.registry});

  @override
  State<StatefulWidget> createState() {
    return _DUINestedScrollViewState();
  }
}

class _DUINestedScrollViewState extends DUIWidgetState<DUINestedScrollView> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return getHeaderWidget(innerBoxIsScrolled);
        },
        body: getBodyWidget());
  }

  @override
  Map<String, Function> getVariables() {
    return {};
  }

  List<Widget> getHeaderWidget(bool innerBoxIsScrolled) {
    final headerWidgetData = widget.data.children['headerWidget'];

    if (headerWidgetData == null) {
      return const [SliverToBoxAdapter(child: SizedBox.shrink())];
    }

    final headerWidget = headerWidgetData.map((e) {
      return BracketScope(
          variables: [('innerBoxIsScrolled', innerBoxIsScrolled)],
          builder: DUIJsonWidgetBuilder(
              data: e, registry: DUIWidgetRegistry.shared));
    }).toList();
    return headerWidget;
  }

  Widget getBodyWidget() {
    final bodyWidgetData = widget.data.children['bodyWidget']?.firstOrNull;

    if (bodyWidgetData == null) {
      return const SizedBox.shrink();
    }

    return DUIWidget(data: bodyWidgetData);
  }
}
