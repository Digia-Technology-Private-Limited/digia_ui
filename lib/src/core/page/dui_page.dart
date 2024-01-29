import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/core/builders/dui_json_widget_builder.dart';
import 'package:digia_ui/src/core/flutter_widgets.dart';
import 'package:digia_ui/src/core/page/dui_page_bloc.dart';
import 'package:digia_ui/src/core/page/dui_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DUIPage extends StatefulWidget {
  const DUIPage({super.key});

  @override
  State<StatefulWidget> createState() => _DUIPageState();
}

class _DUIPageState extends State<DUIPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DUIPageBloc, DUIPageState>(builder: (context, state) {
      Widget bodyWidget;

      if (state.isLoading) {
        bodyWidget = const Center(
          child: SizedBox(
            // TODO -> Resolve Loader from Config
            child: CircularProgressIndicator(color: Colors.blue),
          ),
        );
      } else {
        bodyWidget = state.props?.layout?.body.root.let((root) {
              final builder = DUIJsonWidgetBuilder(
                  data: root, registry: DUIWidgetRegistry.shared);
              return builder.build(context);
            }) ??
            Center(child: Text('Props not found for page: ${state.uid}'));
      }

      final appBar = state.props?.layout?.header?.root.let((root) {
        if (root.type != 'fw/appBar') {
          return null;
        }

        return FW.appBar(root.props);
      });

      return Scaffold(
        appBar: appBar,
        body: SafeArea(child: bodyWidget),
      );
    });
  }

  // Future<DUIPageProps>? _executeOnPageLoadAction(BuildContext context) async {
  //   final action = ActionProp.fromJson(
  //       initData.pageConfig.valueFor(keyPath: 'actions.onPageLoad'));
  //   final json = await ActionHandler().executeAction(context, action);
  //   return DUIPageProps.fromJson(json);
  // }
  // Widget _buildChildWidget(PageBodyListContainer childContainer) {
  //   final widgetFromRegistry = DUIWidgetRegistry[childContainer.child.type]
  //       ?.call(childContainer.child.data);

  //   // TODO: Figure out a fallback in this case.
  //   // Should be logged as well.
  //   // @Vivek, @Anupam, @Tushar
  //   if (widgetFromRegistry == null) {
  //     return Text(
  //         'A widget of type: ${childContainer.child.type} is not found');
  //   }

  //   final childAlignmentInContainer =
  //       toAlignmentGeometry(childContainer.alignChild);
  //   final child = childAlignmentInContainer != null
  //       ? Align(
  //           alignment: childAlignmentInContainer,
  //           child: widgetFromRegistry,
  //         )
  //       : widgetFromRegistry;

  //   return childContainer.styleClass == null
  //       ? child
  //       : DUIContainer(styleClass: childContainer.styleClass, child: child);
  // }

  // @override
  // Widget build(BuildContext context) {
  // final showAppBar =
  //     initData.pageConfig.valueFor(keyPath: 'layout.header.appBar');
  // return Scaffold(
  // resizeToAvoidBottomInset: false,
  // appBar: showAppBar == true
  //     ? AppBar(
  //         title: DUIText.create(const {'text': 'Restaurant Analytics'}),
  //         actions: [
  //           TextButton(
  //               onPressed: () async {
  //                 await PrefUtil.clearStorage();
  //                 await Navigator.of(context).maybePop();
  //               },
  //               child: const Text('Clear AuthToken'))
  //         ],
  //       )
  //     : null,
  // body: FutureBuilder<DUIPageProps>(
  //     future: _executeOnPageLoadAction(context),
  //     builder: (context, snapshot) {
  //       // TODO: Loader config shall change later
  //       if (!snapshot.hasData || snapshot.data == null) {
  //         return const Center(
  //           child: SizedBox(
  //             child: CircularProgressIndicator(color: Colors.blue),
  //           ),
  //         );
  //       }

  //       final rootWidgetData = snapshot.data!.layout.body.root;
  //       final builder = DUIJsonWidgetBuilder(
  //           data: rootWidgetData, registry: DUIWidgetRegistry.shared);
  //       return SafeArea(child: builder.build(context));
  // rootWidgetData.

  // final list = listObject?.children;

  // if (list == null) {
  //   return const Center(child: Text('Currently Not supported!!!'));
  // }

  // Widget widget;

  // if (snapshot.data?.layout.body.allowScroll == false) {
  //   // https: //stackoverflow.com/a/54564767
  //   widget = SafeArea(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: list
  //           .map((item) {
  //             return _buildChildWidget(item);
  //           })
  //           .nonNulls
  //           .toList(),
  //     ),
  //   );
  // } else {
  //   // https://stackoverflow.com/a/52106410
  //   widget = ListView.builder(
  //       itemCount: list.length,
  //       itemBuilder: (context, index) {
  //         final item = list[index];

  //         return _buildChildWidget(item);
  //       });
  // }

  // return listObject?.styleClass == null
  //     ? widget
  //     : DUIContainer(
  //         styleClass: listObject?.styleClass, child: widget);
  //       }),
  // );
  // }
}
