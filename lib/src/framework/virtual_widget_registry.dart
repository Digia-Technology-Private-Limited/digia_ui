import 'base_virtual_widget.dart';
import 'builders.dart';
import 'models/vw_node_data.dart';

typedef VirtualWidgetBuilder = VirtualWidget Function(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry);

class VirtualWidgetRegistry {
  final Map<String, VirtualWidgetBuilder> _builders = {
    'digia/text': textBuilder,
    'digia/richText': richTextBuilder,
    'digia/container': containerBuilder,
    'digia/icon': iconBuilder
  };

  void registerWidget(String type, VirtualWidgetBuilder builder) {
    _builders[type] = builder;
  }

  static final VirtualWidgetRegistry instance =
      VirtualWidgetRegistry._internal();

  factory VirtualWidgetRegistry() {
    return instance;
  }

  VirtualWidgetRegistry._internal();

  VirtualWidget createWidget(VWNodeData data, VirtualWidget? parent) {
    String type = data.type;
    if (!_builders.containsKey(type)) {
      throw Exception('Unknown widget type: $type');
    }

    return _builders[type]!(data, parent, this);
  }

  VirtualWidget? createChild(
      {required VWNodeData data, String key = 'child', VirtualWidget? parent}) {
    final child = data.childGroups?[key]?.firstOrNull;

    if (child == null) return null;

    return createWidget(child, parent);
  }

  List<VirtualWidget?>? createChildren(
      {required VWNodeData data,
      String key = 'children',
      VirtualWidget? parent}) {
    final children = data.childGroups?[key];

    if (children == null || children.isEmpty) return null;

    return children.map((p0) => createChild(data: p0, parent: parent)).toList();
  }
}
