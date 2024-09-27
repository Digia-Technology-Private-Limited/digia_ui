import 'package:flutter/material.dart';

class InternalTabController extends TabController {
  final List<dynamic> dynamicList;

  InternalTabController({
    required this.dynamicList,
    required super.vsync,
    super.animationDuration,
    super.initialIndex,
  }) : super(length: dynamicList.length);
}

class InternalTabControllerProvider extends StatefulWidget {
  final List<dynamic> dynamicList;
  final int initialIndex;
  final double? animationDuration;
  final Widget child;

  const InternalTabControllerProvider({
    super.key,
    required this.dynamicList,
    required this.child,
    this.initialIndex = 0,
    this.animationDuration,
  });

  /// Retrieve the [InternalTabController] from the context or return null if it doesn't exist
  static InternalTabController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            _InternalTabControllerInheritedWidget>()
        ?.tabController;
  }

  /// Retrieve the [InternalTabController] from the context and throw an error if not found
  static InternalTabController of(BuildContext context) {
    final tabController = maybeOf(context);
    assert(tabController != null, 'No InternalTabController found in context');
    return tabController!;
  }

  @override
  _InternalTabControllerProviderState createState() =>
      _InternalTabControllerProviderState();
}

class _InternalTabControllerProviderState
    extends State<InternalTabControllerProvider>
    with SingleTickerProviderStateMixin {
  late InternalTabController _tabController;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  void _initializeTabController() {
    _tabController = InternalTabController(
      dynamicList: widget.dynamicList,
      animationDuration: (widget.animationDuration != null)
          ? secondsToDuration(widget.animationDuration!)
          : null,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  Duration secondsToDuration(double totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60 ~/ 1;
    int milliseconds = ((totalSeconds % 1) * 1000).round();
    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InternalTabControllerInheritedWidget(
      tabController: _tabController,
      child: widget.child,
    );
  }
}

class _InternalTabControllerInheritedWidget extends InheritedWidget {
  final InternalTabController tabController;

  const _InternalTabControllerInheritedWidget({
    required this.tabController,
    required super.child,
  });

  @override
  bool updateShouldNotify(
      covariant _InternalTabControllerInheritedWidget oldWidget) {
    return tabController != oldWidget.tabController;
  }
}
