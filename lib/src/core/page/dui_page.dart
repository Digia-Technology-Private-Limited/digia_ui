import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/core/page/dui_page_bloc.dart';
import 'package:digia_ui/src/core/page/dui_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dui_page_event.dart';

class DUIPage extends StatelessWidget {
  final String pageUid;
  final Function(String methodId, Map<String, dynamic>? data)?
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
            onExternalMethodCalled: onExternalMethodCalled,
            initData: DUIPageInitData(
                identifier: pageUid,
                config: configResolver.getPageConfig(pageUid)!),
            resolver: configResolver)
          ..add(
            InitPageEvent(pageParams: pageArguments),
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
      if (state.isLoading) {
        return const Scaffold(
            body: SafeArea(
                child: Center(
          child: SizedBox(
            // TODO -> Resolve Loader from Config
            child: CircularProgressIndicator(color: Colors.blue),
          ),
        )));
      }

      return state.props?.layout?.root.let((p0) => DUIWidget(data: p0)) ??
          Center(child: Text('Props not found for page: ${state.uid}'));
    });
  }
}
