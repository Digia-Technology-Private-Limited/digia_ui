import '../utils/functional_util.dart';

class TabViewContentProps {
  final bool? isScrollable;
  final double viewportFraction;

  TabViewContentProps({
    required this.isScrollable,
    required this.viewportFraction,
  });

  factory TabViewContentProps.fromJson(Map<String, dynamic> json) {
    return TabViewContentProps(
      isScrollable: as$<bool>(json['isScrollable']),
      viewportFraction: as$<double>(json['viewportFraction']) ?? 1.0,
    );
  }
}
