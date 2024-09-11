import 'package:flutter/material.dart';

class Duicustomtabcontroller extends TabController {
  final List<dynamic>? dynamicList;

  Duicustomtabcontroller({
    int? length,
    this.dynamicList,
    required TickerProvider vsync,
    Duration? animationDuration,
    int initialIndex = 0,
  })  : assert(length != null || dynamicList != null,
            'Either length or dynamicList must be provided'),
        super(
          length: dynamicList?.length ?? length!,
          vsync: vsync,
          initialIndex: initialIndex,
          animationDuration: animationDuration,
        );
}

class DuicustomTabControllerProvider extends StatefulWidget {
  final List<dynamic>? dynamicList;
  final int? length;
  final int initialIndex;
  final double? animationDuration;
  final Widget child;

  const DuicustomTabControllerProvider({
    super.key,
    this.dynamicList,
    this.length,
    this.initialIndex = 0,
    this.animationDuration,
    required this.child,
  });

  /// Retrieve the `Duicustomtabcontroller` from the context or return null if it doesn't exist
  static Duicustomtabcontroller? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            _DuicustomTabControllerInheritedWidget>()
        ?.tabController;
  }

  /// Retrieve the `Duicustomtabcontroller` from the context and throw an error if not found
  static Duicustomtabcontroller of(BuildContext context) {
    final tabController = maybeOf(context);
    assert(tabController != null, 'No Duicustomtabcontroller found in context');
    return tabController!;
  }

  @override
  _DuicustomTabControllerProviderState createState() =>
      _DuicustomTabControllerProviderState();
}

class _DuicustomTabControllerProviderState
    extends State<DuicustomTabControllerProvider>
    with SingleTickerProviderStateMixin {
  late Duicustomtabcontroller _tabController;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  void _initializeTabController() {
    _tabController = Duicustomtabcontroller(
      dynamicList: widget.dynamicList,
      animationDuration: (widget.animationDuration != null)
          ? secondsToDuration(widget.animationDuration!)
          : null,
      length: widget.length,
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
    return _DuicustomTabControllerInheritedWidget(
      tabController: _tabController,
      dynamicList: widget.dynamicList,
      child: widget.child,
    );
  }
}

class _DuicustomTabControllerInheritedWidget extends InheritedWidget {
  final Duicustomtabcontroller tabController;
  final List<dynamic>? dynamicList;

  const _DuicustomTabControllerInheritedWidget({
    required this.tabController,
    this.dynamicList,
    required super.child,
  });

  @override
  bool updateShouldNotify(
      covariant _DuicustomTabControllerInheritedWidget oldWidget) {
    return tabController != oldWidget.tabController ||
        dynamicList != oldWidget.dynamicList;
  }
}
