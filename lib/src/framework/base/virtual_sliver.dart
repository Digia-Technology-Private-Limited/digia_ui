import 'virtual_stateless_widget.dart';

abstract class VirtualSliver<T> extends VirtualStatelessWidget<T> {
  VirtualSliver({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
  });
}
