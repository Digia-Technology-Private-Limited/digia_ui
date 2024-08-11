import 'package:dio/dio.dart';
import 'package:talker/talker.dart';

enum NetworkLogType { success, error }

class NetworkLog extends TalkerLog {
  final String url;
  final RequestOptions requestOptions;
  final Response? response;
  final DioException? err;
  final NetworkLogType type;

  NetworkLog({
    required this.url,
    required this.requestOptions,
    this.response,
    this.err,
    required this.type,
  }) : super('');

  @override
  String get title => 'NETWORK';
}

class PageLog extends TalkerLog {
  List<(String, dynamic, String)> params;
  List<(String, dynamic, String)> states;
  String pageUid;

  PageLog(this.params, this.states, this.pageUid) : super('');

  @override
  String get title => 'PAGE_LOG';
}

class AppStateLog extends TalkerLog {
  final String name;
  final dynamic value;
  final String type;

  AppStateLog(this.name, this.value, this.type) : super('');

  @override
  String get title => 'APP_STATE';
}

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
