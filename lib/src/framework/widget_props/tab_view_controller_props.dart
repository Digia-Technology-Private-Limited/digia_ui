import '../models/types.dart';
import '../utils/types.dart';

class TabViewControllerProps {
  final ExprOr<List>? tabs;
  final ExprOr<int>? initialIndex;

  TabViewControllerProps({required this.tabs, this.initialIndex});

  factory TabViewControllerProps.fromJson(JsonLike json) {
    return TabViewControllerProps(
      tabs: ExprOr.fromJson<List>(json['dynamicList']),
      initialIndex: ExprOr.fromJson<int>(json['initialIndex']),
    );
  }
}
