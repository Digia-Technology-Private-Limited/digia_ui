import '../utils/functional_util.dart';

class TabViewContentProps {
  final bool? isScrollable;
  final double viewportFraction;
  final bool? keepTabsAlive;

  TabViewContentProps({
    required this.isScrollable,
    required this.viewportFraction,
    this.keepTabsAlive,
  });

  factory TabViewContentProps.fromJson(Map<String, dynamic> json) {
    return TabViewContentProps(
      isScrollable: as$<bool>(json['isScrollable']),
      viewportFraction: as$<double>(json['viewportFraction']) ?? 1.0,
      keepTabsAlive: as$<bool>(json['keepTabsAlive']),
    );
  }
}
