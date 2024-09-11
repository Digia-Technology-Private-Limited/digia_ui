// import 'package:flutter/material.dart';

// import '../../../digia_ui.dart';
// import '../../Utils/basic_shared_utils/dui_decoder.dart';
// import '../../Utils/dui_widget_registry.dart';
// import '../../Utils/util_functions.dart';
// import '../../core/bracket_scope_provider.dart';
// import '../../core/builders/common.dart';
// import '../../core/builders/dui_json_widget_builder.dart';
// import '../dui_base_stateful_widget.dart';
// import 'dui_tabview_props.dart';

// class DUITabView1 extends BaseStatefulWidget {
//   const DUITabView1({
//     super.key,
//     required this.registry,
//     required this.data,
//     required this.tabViewProps,
//     required super.varName,
//   });

//   final DUIWidgetRegistry? registry;
//   final DUIWidgetJsonData data;
//   final DUITabView1Props tabViewProps;

//   @override
//   State<DUITabView1> createState() => _DUITabView1State();
// }

// class _DUITabView1State extends DUIWidgetState<DUITabView1> {
//   late TabBarIndicatorSize _indicatorSize;
//   TabBarIndicatorSize? _toTabBarIndicatorSize(dynamic value) => switch (value) {
//         'tab' => TabBarIndicatorSize.tab,
//         'label' => TabBarIndicatorSize.label,
//         _ => null
//       };
//   late final TabController? _controller;
//   @override
//   void initState() {
//     _indicatorSize =
//         _toTabBarIndicatorSize(widget.tabViewProps.indicatorSize) ??
//             TabBarIndicatorSize.tab;

//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _controller = DefaultTabController.maybeOf(context);
//     _controller?.removeListener(_handleTabSelection);
//     _controller?.addListener(_handleTabSelection);
//   }

//   @override
//   void dispose() {
//     _controller?.removeListener(_handleTabSelection);
//     super.dispose();
//   }

//   void _handleTabSelection() {
//     // // Trigger a rebuild when the selected tab changes
//     setState(() {});

//     // Optionally, notify the DUIPageBloc about the selected index
//     // final selectedIndex = _controller?.index;
//     // if (widget.varName != null) {
//     //   context.read<DUIPageBloc>().add(SetStateEvent(events: [
//     //         SingleSetStateEvent(
//     //             variableName: 'selectedIndex',
//     //             context: context,
//     //             value: selectedIndex)
//     //       ], rebuildPage: true));
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // _controller = DefaultTabController.maybeOf(context);
//     final children = widget.data.children['children'] ?? [];

//     if (_controller == null) return _emptyControllerWidget();

//     if (children.isEmpty) return _emptyChildWidget();

//     List items =
//         createDataItemsForDynamicChildren(data: widget.data, context: context);
//     final generateChildrenDynamically =
//         widget.data.dataRef.isNotEmpty && widget.data.dataRef['kind'] != null;

//     return TabBar(
//       controller: _controller,
//       indicatorSize: _indicatorSize,
//       labelPadding: DUIDecoder.toEdgeInsets(widget.tabViewProps.labelPadding),
//       padding: DUIDecoder.toEdgeInsets(widget.tabViewProps.tabBarPadding),
//       unselectedLabelColor: makeColor(widget.tabViewProps.unselectedLabelColor),
//       unselectedLabelStyle:
//           toTextStyle(widget.tabViewProps.unselectedLabelStyle, context),
//       labelStyle: toTextStyle(widget.tabViewProps.selectedLabelStyle, context),
//       dividerColor: makeColor(widget.tabViewProps.dividerColor),
//       labelColor: makeColor(widget.tabViewProps.selectedLabelColor),
//       dividerHeight: widget.tabViewProps.dividerHeight,
//       indicatorColor: makeColor(widget.tabViewProps.indicatorColor),
//       tabs: generateChildrenDynamically
//           ? List.generate(items.length, (index) {
//               final childToRepeat = children.first;
//               return BracketScope(
//                 variables: [('index', index), ('currentItem', items[index])],
//                 builder: DUIJsonWidgetBuilder(
//                   data: childToRepeat,
//                   registry: widget.registry ?? DUIWidgetRegistry.shared,
//                 ),
//               );
//             })
//           : List.generate(children.length, (index) {
//               final builder = DUIJsonWidgetBuilder(
//                   data: children[index], registry: DUIWidgetRegistry.shared);
//               return builder.build(context);
//             }),
//     );
//   }

//   Widget _emptyControllerWidget() {
//     return const Center(
//       child: Text(
//         'No Controller Found on Heirarchy',
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   Widget _emptyChildWidget() {
//     return const Center(
//       child: Text(
//         'Children field is Empty!',
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   @override
//   Map<String, Function> getVariables() {
//     return {
//       'selectedIndex': () {
//         return _controller!.index;
//       }
//     };
//   }
// }

//  // final List<DUITabBarItem> children;
//   // final bool isScrollable;
//   // final EdgeInsetsGeometry? padding;
//   // final Color? indicatorColor;
//   // final double? indicatorThickness;
//   // final EdgeInsetsGeometry? indicatorPadding;
//   // final TabBarIndicatorSize? indicatorType;
//   // final Color? dividerColor;
//   // final double? dividerThickness;
//   // final TabAlignment? tabAlignment; // Optional custom alignment

import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/util_functions.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../dui_base_stateful_widget.dart';
import 'DUICustomTabController.dart';
import 'dui_tabview_props.dart';

class DUITabView1 extends BaseStatefulWidget {
  final DUIWidgetRegistry? registry;
  final DUIWidgetJsonData data;
  final DUITabView1Props tabViewProps;
  const DUITabView1({
    super.key,
    required this.registry,
    required this.data,
    required this.tabViewProps,
    required super.varName,
  });

  @override
  _DUITabView1State createState() => _DUITabView1State();
}

class _DUITabView1State extends DUIWidgetState<DUITabView1>
    with SingleTickerProviderStateMixin {
  late TabBarIndicatorSize _indicatorSize;
  TabBarIndicatorSize? _toTabBarIndicatorSize(dynamic value) => switch (value) {
        'tab' => TabBarIndicatorSize.tab,
        'label' => TabBarIndicatorSize.label,
        _ => null
      };
  late Duicustomtabcontroller _controller;
  @override
  void initState() {
    _indicatorSize =
        _toTabBarIndicatorSize(widget.tabViewProps.indicatorSize) ??
            TabBarIndicatorSize.tab;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller = DuicustomTabControllerProvider.of(context);
    _controller.removeListener(_handleTabSelection);
    _controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_controller.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.data.children['children'] ?? [];

    if (children.isEmpty) return _emptyChildWidget();

    final generateChildrenDynamically = _controller.dynamicList != null;
    final childToRepeat = children.first;
    return TabBar(
      indicatorSize: _indicatorSize,
      controller: _controller,
      padding: DUIDecoder.toEdgeInsets(widget.tabViewProps.tabBarPadding),
      dividerColor: makeColor(widget.tabViewProps.dividerColor),
      dividerHeight: widget.tabViewProps.dividerHeight,
      indicatorColor: makeColor(widget.tabViewProps.indicatorColor),
      tabs: (!generateChildrenDynamically)
          ? List.generate(children.length, (index) {
              final isSelected = _controller.index == index;
              final selectedWidget = DUIJsonWidgetBuilder(
                  data: children[index].children['selectedWidget']!.first,
                  registry: widget.registry!);
              final notSelectedWidget = DUIJsonWidgetBuilder(
                  data: children[index].children['notSelectedWidget']!.first,
                  registry: widget.registry!);
              return AnimatedSwitcher(
                duration: _controller.animationDuration,
                child: isSelected
                    ? selectedWidget.build(context)
                    : notSelectedWidget.build(context),
              );
            })
          : List.generate(children.length, (index) {
              final isSelected = _controller.index == index;
              final selectedWidget = BracketScope(
                variables: [
                  ('index', index),
                  ('currentItem', _controller.dynamicList?[index])
                ],
                builder: DUIJsonWidgetBuilder(
                  data: childToRepeat.children['selectedWidget']!.first,
                  registry: widget.registry ?? DUIWidgetRegistry.shared,
                ),
              );
              final notSelectedWidget = BracketScope(
                variables: [
                  ('index', index),
                  ('currentItem', _controller.dynamicList?[index])
                ],
                builder: DUIJsonWidgetBuilder(
                  data: childToRepeat.children['notSelectedWidget']!.first,
                  registry: widget.registry ?? DUIWidgetRegistry.shared,
                ),
              );
              return AnimatedSwitcher(
                duration: _controller.animationDuration,
                child: isSelected ? selectedWidget : notSelectedWidget,
              );
            }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _emptyChildWidget() {
    return const Center(
      child: Text(
        'Children field is Empty!',
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Map<String, Function> getVariables() {
    return {
      'selectedIndex': () {
        return _controller.index;
      }
    };
  }
}
