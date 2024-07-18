import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef DUIIconDataProvider = IconData Function(Map<String, dynamic> map);
typedef DUIImageProviderFn = ImageProvider Function(String identifier);
typedef DUITextStyleBuilder = TextStyle Function(String identifier);

abstract class DUIPageAction {
  final String type;
  final Map<String, dynamic> data;
  const DUIPageAction._(this.type, this.data);

  factory DUIPageAction.rebuildPage() = _RebuildDUIPage;
}

class _RebuildDUIPage extends DUIPageAction {
  const _RebuildDUIPage() : super._('Action.rebuildPage', const {});
}

class MessagePayload {
  final BuildContext context;
  final String name;
  final Map<String, Object?>? body;
  final Future<Object?> Function(DUIPageAction) dispatchAction;

  const MessagePayload(
      {required this.context,
      required this.name,
      this.body,
      required this.dispatchAction});
}

typedef DUIMessageHandler = void Function(MessagePayload);
