import '../../../digia_ui.dart';
import '../models/types.dart';
import '../utils/types.dart';

class TabViewControllerProps {
  final ExprOr<List>? tabs;
  final ExprOr<int>? initialIndex;
  final ActionFlow? onTabChange;

  TabViewControllerProps(
      {this.onTabChange, required this.tabs, this.initialIndex});

  factory TabViewControllerProps.fromJson(JsonLike json) {
    return TabViewControllerProps(
        tabs: ExprOr.fromJson<List>(json['dynamicList']),
        initialIndex: ExprOr.fromJson<int>(json['initialIndex']),
        onTabChange: ActionFlow.fromJson(json['onTabChange']));
  }
}
