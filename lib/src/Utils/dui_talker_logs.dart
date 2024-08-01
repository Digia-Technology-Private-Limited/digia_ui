import 'dart:convert';

import 'package:talker/talker.dart';

class PageStateLog extends TalkerLog {
  final String stateName;
  final dynamic stateValue;
  final String stateType;

  PageStateLog(this.stateName, this.stateValue, this.stateType)
      : super('$stateName: $stateValue | $stateType');

  @override
  String get title => 'PAGE_STATE';
}

class PageParamLog extends TalkerLog {
  final String paramName;
  final dynamic paramValue;
  final String paramType;

  PageParamLog(this.paramName, this.paramValue, this.paramType)
      : super('$paramName: $paramValue | $paramType');

  @override
  String get title => 'PAGE_PARAM';
}

class ActionLog extends TalkerLog {
  final String actionType;
  final Map<String, dynamic> actionData;

  ActionLog(this.actionType, this.actionData)
      : super('$actionType: ${jsonEncode(actionData)}');

  @override
  String get title => 'ACTION';
}

class EventLog extends TalkerLog {
  final String eventName;
  final Map<String, dynamic> eventPayload;

  EventLog(this.eventName, this.eventPayload)
      : super('$eventName: ${jsonEncode(eventPayload)}');

  @override
  String get title => 'EVENT';
}
