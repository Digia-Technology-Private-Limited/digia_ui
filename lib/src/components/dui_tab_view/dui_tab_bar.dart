import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../dui_base_stateful_widget.dart';
import 'dui_custom_tab_controller.dart';
import 'dui_tab_bar_props.dart';

class DUITabBar extends BaseStatefulWidget {
  final DUIWidgetRegistry? registry;
  final DUIWidgetJsonData data;
  final DUITabBarProps tabBarProps;

  const DUITabBar({
    super.key,
    required this.registry,
    required this.data,
    required this.tabBarProps,
    required super.varName,
  });

  @override
  _DUITabBarState createState() => _DUITabBarState();
}

class _DUITabBarState extends DUIWidgetState<DUITabBar>
    with SingleTickerProviderStateMixin {
  late TabBarIndicatorSize _indicatorSize;
  late DUICustomTabController _controller;

  @override
  void initState() {
    super.initState();
    _indicatorSize = _toTabBarIndicatorSize(widget.tabBarProps.indicatorSize) ??
        TabBarIndicatorSize.tab;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = DUITabControllerProvider.of(context);
    _controller.removeListener(_handleTabSelection);
    _controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TabBar _buildTabBar({
    required bool isScrollable,
    required bool generateChildrenDynamically,
    required List<dynamic> children,
    // required Widget Function(Widget, Animation<double>) animationType,
    Alignment alignment = Alignment.center,
  }) {
    return TabBar(
      isScrollable: isScrollable,
      tabAlignment: isScrollable
          ? alignment == Alignment.centerLeft
              ? TabAlignment.start
              : TabAlignment.center
          : null,
      indicatorSize: _indicatorSize,
      controller: _controller,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      // splashFactory: NoSplash.splashFactory,
      padding: DUIDecoder.toEdgeInsets(widget.tabBarProps.tabBarPadding),
      labelPadding: DUIDecoder.toEdgeInsets(widget.tabBarProps.labelPadding),
      dividerColor: makeColor(widget.tabBarProps.dividerColor),
      dividerHeight: widget.tabBarProps.dividerHeight,
      indicatorWeight: widget.tabBarProps.indicatorWeight ?? 2.0,
      indicatorColor: makeColor(widget.tabBarProps.indicatorColor),
      tabs: List.generate(
          !generateChildrenDynamically
              ? children.length
              : _controller.dynamicList?.length ?? 0, (index) {
        final isSelected = _controller.index == index;
        final selectedWidget =
            generateWidget(children, index, isSelected, true);
        final notSelectedWidget =
            generateWidget(children, index, isSelected, false);
        return isSelected ? selectedWidget : notSelectedWidget;
        // return AnimatedSwitcher(
        //   transitionBuilder: animationType,
        //   duration: _controller.animationDuration,
        //   child: isSelected ? selectedWidget : notSelectedWidget,
        // );
      }),
    );
  }

  Widget generateWidget(List<dynamic> children, int index, bool isSelected,
      bool isSelectedWidget) {
    if (_controller.dynamicList != null) {
      return BracketScope(
        // key:
        //     ValueKey('${isSelectedWidget ? 'selected' : 'notSelected'}_$index'),
        variables: [
          ('index', index),
          ('currentItem', _controller.dynamicList?[index])
        ],
        builder: DUIJsonWidgetBuilder(
          data: children
              .first
              .children[
                  isSelectedWidget ? 'selectedWidget' : 'notSelectedWidget']!
              .first,
          registry: widget.registry ?? DUIWidgetRegistry.shared,
        ),
      );
    } else {
      return SizedBox(
        // key:
        //     ValueKey('${isSelectedWidget ? 'selected' : 'notSelected'}_$index'),
        child: DUIJsonWidgetBuilder(
          data: children[index]
              .children[
                  isSelectedWidget ? 'selectedWidget' : 'notSelectedWidget']!
              .first,
          registry: widget.registry!,
        ).build(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.data.children['children'] ?? [];
    // final animationType =
    //     getTransitionBuilder(widget.tabBarProps.animationType);
    final isScrollable =
        widget.tabBarProps.tabBarScrollable?.valueFor(keyPath: 'value') ??
            false;
    final alignment = DUIDecoder.toAlignment(widget.tabBarProps.tabBarScrollable
            ?.valueFor(keyPath: 'tabAlignment')) ??
        Alignment.center;

    if (children.isEmpty) return _emptyChildWidget();

    return isScrollable
        // ? Align(
        //     alignment: alignment,
        //     child: IntrinsicWidth(
        //       child: _buildTabBar(
        //         isScrollable: true,
        //         generateChildrenDynamically: _controller.dynamicList != null,
        //         children: children,
        //         // animationType: animationType,
        //       ),
        //     ),
        //   )
        ? _buildTabBar(
            isScrollable: true,
            alignment: alignment,
            generateChildrenDynamically: _controller.dynamicList != null,
            children: children,
            // animationType: animationType,
          )
        : _buildTabBar(
            isScrollable: false,
            generateChildrenDynamically: _controller.dynamicList != null,
            children: children,
            // animationType: animationType,
          );
  }

  Widget _emptyChildWidget() {
    return const Center(
      child: Text(
        'Children field is Empty!',
        textAlign: TextAlign.center,
      ),
    );
  }

  // Widget Function(Widget, Animation<double>) getTransitionBuilder(
  //     String? transitionType) {
  //   if (transitionType.isNull) {
  //     return AnimatedSwitcher.defaultTransitionBuilder;
  //   }
  //   switch (transitionType!.toLowerCase()) {
  //     case 'scale':
  //       return (child, animation) =>
  //           ScaleTransition(scale: animation, child: child);
  //     case 'size':
  //       return (child, animation) =>
  //           SizeTransition(sizeFactor: animation, child: child);
  //     case 'scaleandfade':
  //       return (child, animation) => FadeTransition(
  //             opacity: animation,
  //             child: ScaleTransition(scale: animation, child: child),
  //           );
  //     case 'slide':
  //       return (child, animation) => SlideTransition(
  //             position:
  //                 Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
  //                     .animate(animation),
  //             child: child,
  //           );
  //     case 'fadeandslide':
  //       return (child, animation) => FadeTransition(
  //             opacity: animation,
  //             child: SlideTransition(
  //               position: animation.drive(
  //                   Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)),
  //               child: child,
  //             ),
  //           );
  //     case 'fade':
  //     default:
  //       return (child, animation) =>
  //           FadeTransition(opacity: animation, child: child);
  //   }
  // }

  TabBarIndicatorSize? _toTabBarIndicatorSize(dynamic value) => switch (value) {
        'tab' => TabBarIndicatorSize.tab,
        'label' => TabBarIndicatorSize.label,
        _ => null
      };
  @override
  Map<String, Function> getVariables() {
    return {
      'selectedIndex': () {
        return _controller.index;
      },
      'currentItem': () {
        return _controller.dynamicList?[_controller.index];
      }
    };
  }
}

// Builder Code
//  "animationType": {
//           "type": "string",
//           "default":"fade",
//           "panelConfig": {
//             "label": "Animation Type",
//             "selectorType": "DROP_DOWN",
//             "options": [
//               {
//                 "label": "Fade",
//                 "value": "fade"
//               },
//               {
//                 "label": "Size",
//                 "value": "size"
//               },
//               {
//                 "label": "Scale",
//                 "value": "scale"
//               },
//               {
//                 "label": "Scale And Fade",
//                 "value": "scaleandfade"
//               },
//               {
//                 "label": "Slide",
//                 "value": "slide"
//               },
//               {
//                 "label": "Fade And Slide",
//                 "value": "fadeandslide"
//               }
//             ]
//           }
//         },
