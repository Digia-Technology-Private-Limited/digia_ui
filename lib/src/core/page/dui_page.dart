import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/extensions.dart';
import '../../components/dui_widget_scope.dart';
import '../../dui_logger.dart';
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
  final GlobalKey<NavigatorState>? navigatorKey;
  DUIPage({
    super.key,
    required this.pageUid,
    Map<String, dynamic>? pageArgs,
    this.iconDataProvider,
    this.imageProviderFn,
    this.textStyleBuilder,
    this.onMessageReceived,
    this.navigatorKey,
    DUIConfig? config,
  })  : _pageArgs = pageArgs,
        _config = config ?? DigiaUIClient.instance.config;

  @override
  Widget build(BuildContext context) {
    final DUILogger? logger = DeveloperConfig.instance.logger;
    Bloc.observer = TalkerBlocObserver(
      talker: logger?.talker,
      settings: TalkerBlocLoggerSettings(
        enabled: true,
        printEvents: true,
        printChanges: false,
        printTransitions: true,
        printCreations: false,
        printClosings: false,
        printEventFullData: false,
        printStateFullData: false,
        eventFilter: (bloc, event) {
          if (bloc is DUIPageBloc) {
            if (event is BackPressEvent || event is InitPageEvent) {
              _logPageState(
                  bloc, bloc.state, logger, event.runtimeType.toString());
            }
          }
          return true;
        },
      ),
    );
    return BlocProvider(
      create: (context) {
        return DUIPageBloc(
            pageUid: pageUid, config: _config, pageArgs: _pageArgs);
      },
      child: DUIWidgetScope(
          iconDataProvider: iconDataProvider,
          imageProviderFn: imageProviderFn,
          textStyleBuilder: textStyleBuilder,
          onMessageReceived: onMessageReceived,
          navigatorKey: navigatorKey,
          child: const _DUIScreen()),
    );
  }
}

class _DUIScreen extends StatefulWidget {
  const _DUIScreen();

  @override
  State<_DUIScreen> createState() => _DUIScreenState();
}

class _DUIScreenState extends State<_DUIScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DUIPageBloc>().add(InitPageEvent(context));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.tryRead<DUIPageBloc>()?.add(PageLoadedEvent(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DUIPageBloc, DUIPageState>(builder: (context, state) {
      return PopScope(
          onPopInvoked: (didPop) =>
              context.read<DUIPageBloc>().add(BackPressEvent(context, didPop)),
          child: () {
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

            return state.props.layout?.root.let((p0) => DUIWidget(data: p0)) ??
                Center(
                    child: Text('Props not found for page: ${state.pageUid}'));
          }());
    });
  }
}

_logPageState(DUIPageBloc bloc, DUIPageState? state, DUILogger? logger,
    String eventName) {
  if (state == null) {
    return;
  }

  final inputArgs = state.props.inputArgs;
  final variables = state.props.variables;

  if (inputArgs is! Map || variables is! Map) {
    return;
  }

  final params = _mapToList(inputArgs);
  final states = _mapToList(variables);

  logger?.log(PageLog(params, states, state.pageUid, eventName));
}

List<(String, dynamic, String)> _mapToList(Map<String, dynamic>? map) {
  return map?.entries.map((entry) {
        final variable = entry.value;
        return (
          variable.name.toString(),
          variable.value,
          variable.type.toString(),
        );
      }).toList() ??
      [];
}
