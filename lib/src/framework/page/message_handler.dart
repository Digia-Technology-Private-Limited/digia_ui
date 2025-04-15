import '../base/message_handler.dart';

class DUIPageMessageHandler extends DUIMessageHandler {
  final void Function(DUIMessage) onMessage;
  DUIPageMessageHandler(this.onMessage, {super.propagateHandler = true});

  @override
  void handleMessage(DUIMessage message) => onMessage(message);
}
