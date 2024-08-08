import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:talker/talker.dart';

import '../core/page/dui_page_bloc.dart';
import 'extensions.dart';

dynamic _encodeValue(dynamic val) {
  if (val == null) return null;
  if (val is num || val is bool || val is String) return val;
  if (val is List || val is Map) return jsonEncode(val);
  return val.toString();
}

class NetworkLog extends TalkerLog {
  final String? url;
  final String? method;
  final int? statusCode;
  final Map<String, dynamic>? requestHeaders;
  final Map<String, dynamic>? responseHeaders;
  final Map<String, dynamic>? queryParameters;
  final String? contentType;
  final dynamic requestBody;
  final dynamic responseBody;

  NetworkLog({
    this.url,
    this.method,
    this.statusCode,
    this.requestHeaders,
    this.responseHeaders,
    this.queryParameters,
    this.contentType,
    this.requestBody,
    this.responseBody,
  }) : super('''URL: $url | 
            Method: $method | 
            Status Code: ${statusCode ?? 'N/A'} | 
            RequestHeaders: ${_encodeValue(requestHeaders)} |
            ResponseHeaders: ${_encodeValue(responseHeaders)} | 
            Query Parameters: ${_encodeValue(queryParameters)} | 
            Content Type: $contentType | 
            RequestBody: ${_encodeValue(requestBody)} |
            ResponseBody: ${_encodeValue(responseBody)}''');

  @override
  String get title => 'NETWORK';
}

class PageStateLog extends TalkerLog {
  final String pageName;
  final String stateName;
  final dynamic stateValue;
  final String stateType;

  PageStateLog(this.pageName, this.stateName, this.stateValue, this.stateType)
      : super(
            'Page: $pageName | PageState: $stateName | Value: ${_encodeValue(stateValue)} | Type: $stateType');

  @override
  String get title => 'PAGE_STATE';
}

class PageParamLog extends TalkerLog {
  final String pageName;
  final String paramName;
  final dynamic paramValue;
  final String paramType;

  PageParamLog(this.pageName, this.paramName, this.paramValue, this.paramType)
      : super(
            'Page: $pageName | PageParameter: $paramName | Value: ${_encodeValue(paramValue)} | Type: $paramType');

  @override
  String get title => 'PAGE_PARAM';
}

class AppStateLog extends TalkerLog {
  final String name;
  final dynamic value;
  final String type;

  AppStateLog(this.name, this.value, this.type)
      : super('AppState: $name | Value: ${_encodeValue(value)} | Type: $type');

  @override
  String get title => 'APP_STATE';
}

class ActionLog extends TalkerLog {
  final BuildContext context;
  final String actionType;
  final Map<String, dynamic> actionData;

  ActionLog(this.context, this.actionType, this.actionData)
      : super(
            'Page: ${context.tryRead<DUIPageBloc>()?.state.pageUid} | Action: $actionType | Data: ${jsonEncode(actionData)}');

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
