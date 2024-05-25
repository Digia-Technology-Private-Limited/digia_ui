import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef DUIIconDataProvider = IconData Function(Map<String, dynamic> map);
typedef DUIImageProviderFn = ImageProvider Function(String identifier);
typedef DUITextStyleBuilder = TextStyle Function(String identifier);

class MessagePayload {
  final BuildContext context;
  final String name;
  final Map<String, Object?>? body;

  const MessagePayload({required this.context, required this.name, this.body});
}

typedef DUIMessageHandler = void Function(MessagePayload);
