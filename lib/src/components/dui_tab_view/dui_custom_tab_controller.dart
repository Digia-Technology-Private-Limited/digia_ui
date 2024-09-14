import 'package:flutter/material.dart';

class DUICustomTabController extends TabController {
  final List<dynamic>? dynamicList;

  DUICustomTabController({
    int? length,
    this.dynamicList,
    required super.vsync,
    super.animationDuration,
    super.initialIndex,
  })  : assert(length != null || dynamicList != null,
            'Either length or dynamicList must be provided'),
        super(
          length: dynamicList?.length ?? length!,
        );
}

class DUITabControllerProvider extends StatefulWidget {
  final List<dynamic>? dynamicList;
  final int? length;
  final int initialIndex;
  final double? animationDuration;
  final Widget child;

  const DUITabControllerProvider({
    super.key,
    this.dynamicList,
    this.length,
    this.initialIndex = 0,
    this.animationDuration,
    required this.child,
  });

  /// Retrieve the `Duicustomtabcontroller` from the context or return null if it doesn't exist
  static DUICustomTabController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            _DUICustomTabControllerInheritedWidget>()
        ?.tabController;
  }

  /// Retrieve the `Duicustomtabcontroller` from the context and throw an error if not found
  static DUICustomTabController of(BuildContext context) {
    final tabController = maybeOf(context);
    assert(tabController != null, 'No Duicustomtabcontroller found in context');
    return tabController!;
  }

  @override
  _DUITabControllerProviderState createState() =>
      _DUITabControllerProviderState();
}

class _DUITabControllerProviderState extends State<DUITabControllerProvider>
    with SingleTickerProviderStateMixin {
  late DUICustomTabController _tabController;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  void _initializeTabController() {
    _tabController = DUICustomTabController(
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
    return _DUICustomTabControllerInheritedWidget(
      tabController: _tabController,
      dynamicList: widget.dynamicList,
      child: widget.child,
    );
  }
}

class _DUICustomTabControllerInheritedWidget extends InheritedWidget {
  final DUICustomTabController tabController;
  final List<dynamic>? dynamicList;

  const _DUICustomTabControllerInheritedWidget({
    required this.tabController,
    this.dynamicList,
    required super.child,
  });

  @override
  bool updateShouldNotify(
      covariant _DUICustomTabControllerInheritedWidget oldWidget) {
    return tabController != oldWidget.tabController ||
        dynamicList != oldWidget.dynamicList;
  }
}
