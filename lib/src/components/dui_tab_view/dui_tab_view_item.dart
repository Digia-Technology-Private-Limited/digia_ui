import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../core/builders/dui_json_widget_builder.dart';

class DUITabViewItem extends StatefulWidget {
  const DUITabViewItem(
      {required this.registry, Key? key, required this.visibleChildren})
      : super(key: key);
  final DUIWidgetRegistry registry;
  final List<DUIWidgetJsonData> visibleChildren;

  @override
  State<DUITabViewItem> createState() => _DUITabViewItemState();
}

class _DUITabViewItemState extends State<DUITabViewItem> {
  @override
  Widget build(BuildContext context) {
    final builder = DUIJsonWidgetBuilder(
        data: widget.visibleChildren.first, registry: widget.registry);
    return builder.build(context);
  }
}
