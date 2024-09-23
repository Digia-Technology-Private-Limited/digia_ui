import 'package:flutter/widgets.dart';

class DUIMessage {
  final BuildContext context;
  final String name;
  final Object? payload;

  const DUIMessage({
    required this.context,
    required this.name,
    this.payload,
  });
}

class DUIPageMessageHandler extends DUIMessageHandler {
  final void Function(DUIMessage) onMessage;
  DUIPageMessageHandler(this.onMessage, {super.propagateHandler = true});

  @override
  void handleMessage(DUIMessage message) => onMessage(message);
}

abstract class DUIMessageHandler {
  final bool propagateHandler;
  DUIMessageHandler({this.propagateHandler = true});

  void handleMessage(DUIMessage message);
}
