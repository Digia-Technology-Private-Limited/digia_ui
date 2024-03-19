import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/config_resolver.dart';
import 'package:digia_ui/src/core/page/dui_page_bloc.dart';
import 'package:digia_ui/src/core/page/dui_page_state.dart';
import 'package:digia_ui/src/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dui_page_event.dart';

class DUIPage extends StatelessWidget {
  final String pageUid;
  final Map<String, dynamic>? _pageArgs;
  final DUIIconDataProvider? iconDataProvider;
  final DUIImageProviderFn? imageProviderFn;
  final DUITextStyleBuilder? textStyleBuilder;
  final DUIExternalFunctionHandler? externalFunctionHandler;
  final DUIConfig _config;

  DUIPage(
      {super.key,
      required this.pageUid,
      Map<String, dynamic>? pageArgs,
      this.iconDataProvider,
      this.imageProviderFn,
      this.textStyleBuilder,
      this.externalFunctionHandler,
      DUIConfig? config})
      : _pageArgs = pageArgs,
        _config = config ?? DigiaUIClient.instance.config;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return DUIPageBloc(
            pageUid: pageUid, onExternalMethodCalled: null, config: _config)
          ..add(InitPageEvent(pageParams: _pageArgs));
      },
      child: _DUIScreen(
          iconDataProvider: iconDataProvider,
          imageProviderFn: imageProviderFn,
          textStyleBuilder: textStyleBuilder,
          externalFunctionHandler: externalFunctionHandler),
    );
  }
}

class _DUIScreen extends StatefulWidget {
  final DUIIconDataProvider? iconDataProvider;
  final DUIImageProviderFn? imageProviderFn;
  final DUITextStyleBuilder? textStyleBuilder;
  final DUIExternalFunctionHandler? externalFunctionHandler;

  const _DUIScreen({
    this.iconDataProvider,
    this.imageProviderFn,
    this.textStyleBuilder,
    this.externalFunctionHandler,
  });

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

      return state.props.layout?.root.let((p0) {
            return DUIWidgetScope(
                iconDataProvider: widget.iconDataProvider,
                imageProviderFn: widget.imageProviderFn,
                textStyleBuilder: widget.textStyleBuilder,
                externalFunctionHandler: widget.externalFunctionHandler,
                pageVars: state.props.variables,
                child: DUIWidget(data: p0));
          }) ??
          Center(child: Text('Props not found for page: ${state.pageUid}'));
    });
  }
}
