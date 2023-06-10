import 'package:digia_ui/Utils/dui_widget_list_registry.dart';
import 'package:digia_ui/Utils/extensions.dart';
import 'package:digia_ui/core/action/action_handler.dart';
import 'package:digia_ui/core/action/action_prop.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:digia_ui/core/page/page_init_data.dart';
import 'package:digia_ui/core/page/props/dui_page_props.dart';
import 'package:flutter/material.dart';

class DUIPage extends StatefulWidget {
  final PageInitData initData;
  const DUIPage({super.key, required this.initData});

  @override
  State<StatefulWidget> createState() => _DUIPageState();
}

class _DUIPageState extends State<DUIPage> {
  late PageInitData initData;

  Future<DUIPageProps>? _executeOnPageLoadAction(BuildContext context) async {
    final action = ActionProp.fromJson(
        initData.pageConfig.valueFor(keyPath: 'actions.onPageLoad'));
    final json = await ActionHandler().executeAction(context, action);
    return DUIPageProps.fromJson(json);
  }

  @override
  void initState() {
    initData = widget.initData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Test Page")),
      body: FutureBuilder<DUIPageProps>(
          future: _executeOnPageLoadAction(context),
          builder: (context, snapshot) {
            // TODO: Loader config shall change later
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(color: Colors.blue[100]),
                ),
              );
            }

            final listObject = snapshot.data?.layout.body.list;
            final list = listObject?.children;

            if (list == null) {
              return const Center(child: Text('Currently Not supported!!!'));
            }

            final widget = ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];

                  final widgetFromRegistry =
                      DUIWidgetRegistry[item.child.type]?.call(item.child.data);

                  final child = item.wrap
                      ? Wrap(children: [widgetFromRegistry])
                      : widgetFromRegistry;

                  return DUIContainer(
                      styleClass: item.styleClass, child: child);
                });

            return listObject?.styleClass == null
                ? widget
                : DUIContainer(
                    styleClass: listObject?.styleClass, child: widget);
          }),
    );
  }
}
