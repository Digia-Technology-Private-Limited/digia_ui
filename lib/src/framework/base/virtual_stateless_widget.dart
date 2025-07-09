import 'virtual_leaf_stateless_widget.dart';
import 'virtual_widget.dart';

abstract class VirtualStatelessWidget<T> extends VirtualLeafStatelessWidget<T> {
  Map<String, List<VirtualWidget>>? childGroups;

  VirtualStatelessWidget({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.refName,
    required this.childGroups,
  });

  VirtualWidget? get child => childOf('child');
  List<VirtualWidget>? get children => childrenOf('children');

  VirtualWidget? childOf(String key) {
    return childGroups?[key]?.firstOrNull;
  }

  List<VirtualWidget>? childrenOf(String key) {
    return childGroups?[key];
  }
}
