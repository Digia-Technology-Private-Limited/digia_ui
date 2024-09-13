import 'virtual_widget.dart';

abstract class VirtualLeafStatelessWidget extends VirtualWidget {
  Map<String, dynamic> props;
  Map<String, dynamic>? commonProps;

  VirtualLeafStatelessWidget({
    required this.props,
    required this.commonProps,
    required super.parent,
    required super.refName,
  });
}
