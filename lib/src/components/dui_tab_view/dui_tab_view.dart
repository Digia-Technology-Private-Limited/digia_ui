import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/core/builders/dui_json_widget_builder.dart';
import 'package:flutter/material.dart';

class DUITabView extends StatefulWidget {
  final List<DUIWidgetJsonData> children;
  final DUIWidgetRegistry? registry;
  const DUITabView({required this.children, this.registry, Key? key})
      : super(key: key);

  @override
  State<DUITabView> createState() => _DUITabViewState();
}

class _DUITabViewState extends State<DUITabView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.children.length,
      child: Column(
        children: [
          TabBar(
            tabs: List.generate(
                widget.children.length,
                (index) =>
                    Text(widget.children[index].props['title'] ?? 'title')),
          ),
          Expanded(
              child: TabBarView(
                  children: widget.children.map((e) {
            final builder =
                DUIJsonWidgetBuilder(data: e, registry: widget.registry!);
            return builder.build(context);
          }).toList()))
        ],
      ),
    );
  }
}
