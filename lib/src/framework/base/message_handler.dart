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

abstract class DUIMessageHandler {
  final bool propagateHandler;
  DUIMessageHandler({this.propagateHandler = true});

  void handleMessage(DUIMessage message);
}
