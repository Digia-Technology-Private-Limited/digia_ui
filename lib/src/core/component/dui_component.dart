import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/extensions.dart';
import '../../components/dui_widget.dart';
import '../../components/dui_widget_scope.dart';
import '../../config_resolver.dart';
import '../../digia_ui_client.dart';
import '../../types.dart';
import 'dui_component_bloc.dart';
import 'dui_component_event.dart';
import 'dui_component_state.dart';

class DUIComponent extends StatelessWidget {
  final String componentUid;
  final Map<String, dynamic>? _componentArgs;
  final DUIIconDataProvider? iconDataProvider;
  final DUIImageProviderFn? imageProviderFn;
  final DUITextStyleBuilder? textStyleBuilder;
  final DUIMessageHandler? onMessageReceived;
  final DUIConfig _config;
  final GlobalKey<NavigatorState>? navigatorKey;
  DUIComponent({
    super.key,
    required this.componentUid,
    Map<String, dynamic>? componentArgs,
    this.iconDataProvider,
    this.imageProviderFn,
    this.textStyleBuilder,
    this.onMessageReceived,
    this.navigatorKey,
    DUIConfig? config,
  })  : _componentArgs = componentArgs,
        _config = config ?? DigiaUIClient.instance.config;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return DUIComponentBloc(
            componentUid: componentUid,
            config: _config,
            componentArgs: _componentArgs);
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
    context.read<DUIComponentBloc>().add(InitComponentEvent(context));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.tryRead<DUIComponentBloc>()?.add(ComponentLoadedEvent(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DUIComponentBloc, DUIComponentState>(
        builder: (context, state) {
      return PopScope(
          onPopInvoked: (didPop) => context
              .read<DUIComponentBloc>()
              .add(BackPressEvent(context, didPop)),
          child: () {
            if (state.isLoading) {
              return const Scaffold(
                  body: SafeArea(
                      child: Center(
                child: SizedBox(
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
              )));
            }

            return state.props.layout?.root.let((p0) => DUIWidget(data: p0)) ??
                Center(
                    child: Text(
                        'Props not found for component: ${state.componentUid}'));
          }());
    });
  }
}
