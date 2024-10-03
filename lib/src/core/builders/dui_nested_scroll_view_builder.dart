import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
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
  late ValueNotifier<dynamic> _streamValueNotifier;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _streamValueNotifier = ValueNotifier<double>(0.0);

    _scrollController = ScrollController(
      keepScrollOffset: true,
    );
    _scrollController.addListener(() {
      _streamValueNotifier.value = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (cntx, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(cntx),
              sliver: getHeaderWidget(innerBoxIsScrolled),
            ),
          ];
        },
        body: getBodyWidget());
  }

  Stream<dynamic> getListStream(dynamic offSet) {
    return Stream.value(offSet);
  }

  @override
  void dispose() {
    _streamValueNotifier.dispose();
    super.dispose();
  }

  Widget? getHeaderWidget(bool innerBoxIsScrolled) {
    final headerWidgetData = widget.data.children['headerWidget'];

    if (headerWidgetData == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final headerWidget = headerWidgetData.let((e) {
      if (e.isNullOrEmpty) return null;

      return BracketScope(
          variables: [('innerBoxIsScrolled', innerBoxIsScrolled)],
          builder: DUIJsonWidgetBuilder(
              data: e.first, registry: DUIWidgetRegistry.shared));
    });
    return headerWidget;
  }

  Widget getBodyWidget() {
    final bodyWidgetData = widget.data.children['bodyWidget']?.firstOrNull;

    if (bodyWidgetData == null) {
      return const SizedBox.shrink();
    }

    return DUIWidget(data: bodyWidgetData);
  }

  @override
  Map<String, Function> getVariables() {
    return {
      'scrollNotifier': () => _streamValueNotifier,
    };
  }
}
