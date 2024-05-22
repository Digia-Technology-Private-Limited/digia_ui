import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../analytics/mixpanel.dart';
import '../../components/dui_widget_scope.dart';
import '../../types.dart';
import 'dui_page_bloc.dart';
import 'dui_page_event.dart';
import 'dui_page_state.dart';

class DUIPage extends StatelessWidget {
  final String pageUid;
  final Map<String, dynamic>? _pageArgs;
  final DUIIconDataProvider? iconDataProvider;
  final DUIImageProviderFn? imageProviderFn;
  final DUITextStyleBuilder? textStyleBuilder;
  final DUIMessageHandler? onMessageReceived;
  final DUIConfig _config;

  DUIPage(
      {super.key,
      required this.pageUid,
      Map<String, dynamic>? pageArgs,
      this.iconDataProvider,
      this.imageProviderFn,
      this.textStyleBuilder,
      this.onMessageReceived,
      DUIConfig? config})
      : _pageArgs = pageArgs,
        _config = config ?? DigiaUIClient.instance.config {
    MixpanelManager.instance
        ?.track('startPage', properties: {'pageUid': pageUid});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return DUIPageBloc(
            pageUid: pageUid,
            onExternalMethodCalled: null,
            config: _config,
            pageArgs: _pageArgs);
      },
      child: _DUIScreen(
          iconDataProvider: iconDataProvider,
          imageProviderFn: imageProviderFn,
          textStyleBuilder: textStyleBuilder,
          onMessageReceived: onMessageReceived),
    );
  }
}

class _DUIScreen extends StatefulWidget {
  final DUIIconDataProvider? iconDataProvider;
  final DUIImageProviderFn? imageProviderFn;
  final DUITextStyleBuilder? textStyleBuilder;
  final DUIMessageHandler? onMessageReceived;

  const _DUIScreen({
    this.iconDataProvider,
    this.imageProviderFn,
    this.textStyleBuilder,
    this.onMessageReceived,
  });

  @override
  State<_DUIScreen> createState() => _DUIScreenState();
}

class _DUIScreenState extends State<_DUIScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DUIPageBloc>().add(InitPageEvent(context));
  }

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
                onMessageReceived: widget.onMessageReceived,
                child: DUIWidget(data: p0));
          }) ??
          Center(child: Text('Props not found for page: ${state.pageUid}'));
    });
  }
}
