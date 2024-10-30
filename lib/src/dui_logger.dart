import 'dart:async';

import 'package:dio/dio.dart';

enum LogType {
  network,
  action,
  event,
  entity,
}

class DUILogger {
  final StreamController<Map<String, Object?>> _logController;

  DUILogger()
      : _logController = StreamController<Map<String, Object?>>.broadcast();

  Stream<Map<String, Object?>> get logStream => _logController.stream;

  void log({
    required LogType type,
    required Map<String, Object?> data,
    DateTime? timestamp,
  }) {
    final logEntry = {
      'type': type.name.toUpperCase(),
      'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
      ...data,
    };

    _logController.add(logEntry);
  }

  // Helper methods for different types of logs
  void logNetwork({
    required String url,
    required RequestOptions requestOptions,
    Response? response,
    DioException? error,
    required String networkType,
  }) {
    log(
      type: LogType.network,
      data: {
        'url': url,
        'requestOptions': requestOptions,
        'response': response,
        'error': error,
        'networkType': networkType,
      },
    );
  }

  void logEntity({
    required String entitySlug,
    required String eventName,
    required Map<String, Object?> argDefs,
    required Map<String, Object?> initStateDefs,
    required Map<String, Object?> stateContainerVariables,
  }) {
    log(
      type: LogType.entity,
      data: {
        'entitySlug': entitySlug,
        'eventName': eventName,
        'argDefs': argDefs,
        'initStateDefs': initStateDefs,
        'stateContainerVariables': stateContainerVariables,
      },
    );
  }

  void logAction({
    required String entitySlug,
    required String actionType,
    required Map<String, Object?> actionData,
  }) {
    log(
      type: LogType.action,
      data: {
        'entitySlug': entitySlug,
        'actionType': actionType,
        'actionData': actionData,
      },
    );
  }

  void logEvent({
    required String eventName,
    required Map<String, Object?> eventPayload,
  }) {
    log(
      type: LogType.event,
      data: {
        'eventName': eventName,
        'eventPayload': eventPayload,
      },
    );
  }

  void dispose() {
    _logController.close();
  }
}
