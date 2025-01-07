import 'dart:async';

import 'package:dio/dio.dart';

import 'framework/utils/types.dart';

enum LogType {
  network,
  action,
  event,
  entity,
  error,
}

class DUILogger {
  final StreamController<JsonLike> _logController;

  DUILogger() : _logController = StreamController<JsonLike>.broadcast();

  Stream<JsonLike> get logStream => _logController.stream;

  void log({
    required LogType type,
    required JsonLike data,
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
    required JsonLike argDefs,
    required JsonLike initStateDefs,
    required JsonLike stateContainerVariables,
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
    required JsonLike actionData,
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
    required JsonLike eventPayload,
  }) {
    log(
      type: LogType.event,
      data: {
        'eventName': eventName,
        'eventPayload': eventPayload,
      },
    );
  }

  void logError({
    required String error,
    required JsonLike metaData,
  }) {
    log(
      type: LogType.error,
      data: {
        'error': error,
        'metaData': metaData,
      },
    );
  }

  void dispose() {
    _logController.close();
  }
}
