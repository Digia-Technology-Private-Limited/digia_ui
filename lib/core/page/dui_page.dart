import 'package:digia_ui/Utils/dui_widget_list_registry.dart';
import 'package:digia_ui/Utils/extensions.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/core/action/action_handler.dart';
import 'package:digia_ui/core/action/action_prop.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:digia_ui/core/page/page_init_data.dart';
import 'package:digia_ui/core/page/props/dui_page_props.dart';
import 'package:digia_ui/core/pref/pref_util.dart';
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

  Widget _buildChildWidget(PageBodyListContainer childContainer) {
    final widgetFromRegistry = DUIWidgetRegistry[childContainer.child.type]
        ?.call(childContainer.child.data);

    if (widgetFromRegistry == null) {
      return Text(
          'A widget of type: ${childContainer.child.type} is not found');
    }

    final child = childContainer.wrap
        ? Wrap(children: [widgetFromRegistry])
        : widgetFromRegistry;

    return childContainer.styleClass == null
        ? child
        : DUIContainer(styleClass: childContainer.styleClass, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final showAppBar =
        initData.pageConfig.valueFor(keyPath: 'layout.header.appBar');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // TODO: Remove Custom AppBar logic
      appBar: showAppBar == true
          ? AppBar(
              title: DUIText.create(const {'text': 'Restaurant Analytics'}),
              actions: [
                TextButton(
                    onPressed: () async {
                      await PrefUtil.clearStorage();
                      await Navigator.of(context).maybePop();
                    },
                    child: const Text('Clear AuthToken'))
              ],
            )
          : null,
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

            Widget widget;

            if (snapshot.data?.layout.body.allowScroll == false) {
              widget = Column(
                children: list
                    .map((child) {
                      return _buildChildWidget(child);
                    })
                    .nonNulls
                    .toList(),
              );
            } else {
              widget = ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];

                    return _buildChildWidget(item);
                  });
            }

            return listObject?.styleClass == null
                ? widget
                : DUIContainer(
                    styleClass: listObject?.styleClass, child: widget);
          }),
    );
  }
}
