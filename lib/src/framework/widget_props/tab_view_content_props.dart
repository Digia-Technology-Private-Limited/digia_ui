import '../models/types.dart';

import '../utils/object_util.dart';
import '../utils/types.dart';

class TabViewContentProps {
  final bool? isScrollable;
  final double viewportFraction;
  final ExprOr<bool>? keepTabsAlive;

  TabViewContentProps({
    required this.isScrollable,
    required this.viewportFraction,
    this.keepTabsAlive,
  });

  factory TabViewContentProps.fromJson(JsonLike json) {
    return TabViewContentProps(
      isScrollable: json['isScrollable']?.to<bool>(),
      viewportFraction: json['viewportFraction']?.to<double>() ?? 1.0,
      keepTabsAlive: ExprOr.fromJson(json['keepTabsAlive']),
    );
  }
}
