import 'package:talker/talker.dart';

class ActionLog extends TalkerLog {
  final String pageName;
  final String actionType;
  final Map<String, dynamic> actionData;

  ActionLog(this.pageName, this.actionType, this.actionData) : super('');

  @override
  String get title => 'ACTION';
}

class EventLog extends TalkerLog {
  final String eventName;
  final Map<String, dynamic> eventPayload;

  EventLog(this.eventName, this.eventPayload) : super('');

  @override
  String get title => 'EVENT';
}
