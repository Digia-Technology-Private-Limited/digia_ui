import 'package:flutter/material.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import 'internal_tab_controller.dart';

enum TabBarAlignment { start, center, end }

class InternalTabBar extends StatefulWidget {
  final TabBarIndicatorSize? tabBarIndicatorSize;
  final bool tabBarScrollable;
  final Alignment tabBarAlignment;
  // final List<Widget> children;
  final Color? dividerColor;
  final Color? indicatorColor;
  final double? indicatorWeight;
  final double? dividerHeight;
  final EdgeInsetsGeometry? tabBarPadding;
  final EdgeInsetsGeometry? labelPadding;
  final List<Widget> selectedWidget;
  final List<Widget> notSelectedWidget;
  const InternalTabBar({
    super.key,
    this.tabBarIndicatorSize,
    this.tabBarScrollable = false,
    this.tabBarAlignment = Alignment.center,
    this.selectedWidget = const [],
    this.notSelectedWidget = const [],
    this.dividerColor,
    this.indicatorColor,
    this.indicatorWeight,
    this.dividerHeight,
    this.tabBarPadding,
    this.labelPadding,
  });

  @override
  _InternalTabBarState createState() => _InternalTabBarState();
}

class _InternalTabBarState extends State<InternalTabBar>
    with SingleTickerProviderStateMixin {
  late TabBarIndicatorSize _indicatorSize;
  late InternalTabController _controller;

  @override
  void initState() {
    super.initState();
    _indicatorSize = widget.tabBarIndicatorSize ?? TabBarIndicatorSize.tab;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = InternalTabControllerProvider.of(context);
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
    required List<Widget> selectedWidgetList,
    required List<Widget> notSelectedWidgetList,
    // required List<dynamic> children,
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
      padding: widget.tabBarPadding,
      labelPadding: widget.labelPadding,
      dividerColor: widget.dividerColor,
      dividerHeight: widget.dividerHeight,
      indicatorWeight: widget.indicatorWeight ?? 2.0,
      indicatorColor: widget.indicatorColor,
      tabs: List.generate(
          !generateChildrenDynamically
              ? selectedWidgetList.length
              : _controller.dynamicList?.length ?? 0, (index) {
        final isSelected = _controller.index == index;
        final selectedWidget =
            generateWidget(selectedWidgetList, index, isSelected, true);
        final notSelectedWidget =
            generateWidget(notSelectedWidgetList, index, isSelected, false);
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
      return children[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedWidget.length != widget.notSelectedWidget.length) {
      return const Text(
          'selectedWidget and not Selected widget length is not same');
    }
    // final children = widget.data.children['children'] ?? [];
    // final animationType =
    //     getTransitionBuilder(widget.tabBarProps.animationType);
    final isScrollable = widget.tabBarScrollable;
    final alignment = widget.tabBarAlignment;

    // if (children.isEmpty) return _emptyChildWidget();

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
            selectedWidgetList: widget.selectedWidget,
            notSelectedWidgetList: widget.notSelectedWidget,
            // children: widget.children,
            // animationType: animationType,
          )
        : _buildTabBar(
            isScrollable: false,
            generateChildrenDynamically: _controller.dynamicList != null,
            selectedWidgetList: widget.selectedWidget,
            notSelectedWidgetList: widget.notSelectedWidget,
            // children: widget.children,
            // animationType: animationType,
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

  // @override
  // Map<String, Function> getVariables() {
  //   return {
  //     'selectedIndex': () {
  //       return _controller.index;
  //     },
  //     'currentItem': () {
  //       return _controller.dynamicList?[_controller.index];
  //     }
  //   };
  // }
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