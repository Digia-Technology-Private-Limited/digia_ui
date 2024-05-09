import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/core/builders/dui_json_widget_builder.dart';
import 'package:flutter/material.dart';

class DUITabViewItem extends StatefulWidget {
  const DUITabViewItem({required this.registry, Key? key, required this.children}) : super(key: key);
  final DUIWidgetRegistry registry;
  final List<DUIWidgetJsonData> children;

  @override
  State<DUITabViewItem> createState() => _DUITabViewItemState();
}

class _DUITabViewItemState extends State<DUITabViewItem> {
  @override
  Widget build(BuildContext context) {
    final builder = DUIJsonWidgetBuilder(data: widget.children.first, registry: widget.registry);
    return builder.build(context);
  }
}
