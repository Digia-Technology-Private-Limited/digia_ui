import 'base_virtual_widget.dart';
import 'models/vw_node_data.dart';
import 'virtual_widget_registry.dart';
import 'widgets/container.dart';
import 'widgets/icon.dart';
import 'widgets/rich_text.dart';
import 'widgets/text.dart';

Map<String, List<VirtualWidget>>? _createChildGroups(
    Map<String, List<VWNodeData>>? childGroups,
    VirtualWidget? parent,
    VirtualWidgetRegistry registry) {
  if (childGroups == null || childGroups.isEmpty) return null;

  return childGroups.map((key, childrenData) {
    return MapEntry(
      key,
      childrenData.map((data) => registry.createWidget(data, parent)).toList(),
    );
  });
}

VWText textBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWText(
    data.props,
    commonProps: data.commonProps,
    parent: parent,
  );
}

VWRichText richTextBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWRichText(
    data.props,
    commonProps: data.commonProps,
    parent: parent,
  );
}

VWContainer containerBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWContainer(data.props,
      commonProps: data.commonProps,
      parent: parent,
      childGroups: _createChildGroups(data.childGroups, parent, registry));
}

VWIcon iconBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWIcon(
    data.props,
    commonProps: data.commonProps,
    parent: parent,
  );
}
