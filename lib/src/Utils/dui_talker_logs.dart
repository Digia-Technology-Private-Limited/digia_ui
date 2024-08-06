import 'dart:convert';

import 'package:talker/talker.dart';

dynamic _encodeValue(dynamic val) {
  if (val == null) return null;
  if (val is num || val is bool || val is String) return val;
  if (val is List || val is Map) return jsonEncode(val);
  return val.toString();
}

class NetworkLog extends TalkerLog {
  final String url;
  final String method;
  final int? statusCode;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? queryParameters;
  final String contentType;
  final Map<String, dynamic>? body;

  NetworkLog({
    required this.url,
    required this.method,
    this.statusCode,
    this.headers,
    this.queryParameters,
    this.contentType = '',
    this.body,
  }) : super('''URL: $url | 
            Method: $method | 
            Status Code: ${statusCode ?? 'N/A'} | 
            Headers: ${_encodeValue(headers)} | 
            Query Parameters: ${_encodeValue(queryParameters)} | 
            Content Type: $contentType | 
            Body: ${_encodeValue(body)}''');

  @override
  String get title => 'NETWORK';
}

class PageStateLog extends TalkerLog {
  final String stateName;
  final dynamic stateValue;
  final String stateType;

  PageStateLog(this.stateName, this.stateValue, this.stateType)
      : super('$stateName: ${_encodeValue(stateValue)} | $stateType');

  @override
  String get title => 'PAGE_STATE';
}

class PageParamLog extends TalkerLog {
  final String paramName;
  final dynamic paramValue;
  final String paramType;

  PageParamLog(this.paramName, this.paramValue, this.paramType)
      : super('PageParam $paramName: ${_encodeValue(paramValue)} | $paramType');

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

class NavigationLog extends TalkerLog {
  final String pageName;

  NavigationLog(this.pageName) : super(pageName);

  @override
  String get title => 'NAVIGATION';
}
