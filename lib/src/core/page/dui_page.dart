import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/core/flutter_widgets.dart';
import 'package:digia_ui/src/core/page/dui_page_bloc.dart';
import 'package:digia_ui/src/core/page/dui_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/dui_widget.dart';
import 'dui_page_event.dart';

class DUIPage extends StatelessWidget {
  final String pageUid;
  final Function({String methodId, Map<String, dynamic>? data})?
      onExternalMethodCalled;
  final Map<String, dynamic>? pageArguments;

  const DUIPage({
    super.key,
    required this.pageUid,
    this.pageArguments,
    this.onExternalMethodCalled,
  });

  @override
  Widget build(BuildContext context) {
    final configResolver = DigiaUIClient.getConfigResolver();
    return BlocProvider(
      create: (context) {
        return DUIPageBloc(
            initData: DUIPageInitData(
                identifier: pageUid,
                config: configResolver.getPageConfig(pageUid)!),
            resolver: configResolver)
          ..add(
            InitPageEvent(),
          );
      },
      child: _DUIScreen(),
    );
  }
}

class _DUIScreen extends StatefulWidget {
  @override
  State<_DUIScreen> createState() => _DUIScreenState();
}

class _DUIScreenState extends State<_DUIScreen> {
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
        bodyWidget = state.props?.layout?.body.root
                .let((root) => DUIWidget(data: root)) ??
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
}
