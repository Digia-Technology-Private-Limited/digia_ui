import 'package:digia_inspector_core/digia_inspector_core.dart';

import 'action_descriptor.dart';
import 'base/action.dart';

class ActionExecutionContext {
  final ActionObserver actionObserver;
  final ObservabilityContext observabilityContext;

  ActionExecutionContext({
    required this.actionObserver,
    required this.observabilityContext,
  });

  void notifyPending({
    required String eventId,
    required String parentId,
    required ActionType type,
    required Map<String, dynamic> definition,
  }) {
    final log = _makeLog(
      ActionStatus.pending,
      parentId: parentId,
      actionDefinition: definition,
      actionType: type,
      eventId: eventId,
    );
    actionObserver.onActionPending(log);
  }

  void notifyStart({
    required String eventId,
    required String parentId,
    required ActionDescriptor descriptor,
  }) {
    final log = _makeLog(
      ActionStatus.running,
      parentId: parentId,
      actionDefinition: descriptor.definition,
      actionType: descriptor.type,
      eventId: eventId,
    );
    actionObserver.onActionStart(log);
  }

  void notifyProgress({
    required String eventId,
    required String parentId,
    required ActionDescriptor descriptor,
    required Map<String, dynamic> details,
  }) {
    final log = _makeLog(
      ActionStatus.running,
      parentId: parentId,
      actionDefinition: descriptor.definition,
      actionType: descriptor.type,
      eventId: eventId,
      progressData: details,
    );
    actionObserver.onActionProgress(log);
  }

  void notifyComplete({
    required String eventId,
    required String parentId,
    required ActionDescriptor descriptor,
    required Object? error,
    required StackTrace? stackTrace,
  }) {
    final status = error == null ? ActionStatus.completed : ActionStatus.error;
    final log = _makeLog(
      status,
      parentId: parentId,
      error: error,
      stackTrace: stackTrace,
      actionDefinition: descriptor.definition,
      actionType: descriptor.type,
      eventId: eventId,
      resolvedParameters: descriptor.resolvedParameters,
    );
    actionObserver.onActionComplete(log);
  }

  void notifyDisabled({
    required String eventId,
    required String parentId,
    required ActionDescriptor descriptor,
    required String reason,
  }) {
    final log = _makeLog(
      ActionStatus.disabled,
      parentId: parentId,
      actionDefinition: descriptor.definition,
      metadata: {'reason': reason},
      resolvedParameters: descriptor.resolvedParameters,
      actionType: descriptor.type,
      eventId: eventId,
    );
    actionObserver.onActionDisabled(log);
  }

  ActionLog _makeLog(
    ActionStatus status, {
    Map<String, dynamic>? actionDefinition,
    Map<String, dynamic>? resolvedParameters,
    ActionType? actionType,
    String? eventId,
    String? parentId,
    Map<String, dynamic>? progressData,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic> metadata = const {},
  }) {
    return ActionLog(
      eventId: eventId ?? _uuid(),
      actionId: eventId ?? _uuid(),
      actionType: actionType?.value ?? '',
      status: status,
      timestamp: DateTime.now(),
      executionTime: null, // filled by inspector manager if needed
      parentEventId: parentId,
      sourceChain: observabilityContext.sourceChain,
      triggerName: observabilityContext.triggerType,
      actionDefinition: actionDefinition ?? {},
      resolvedParameters: resolvedParameters ?? {},
      progressData: progressData,
      error: error,
      errorMessage: error?.toString(),
      stackTrace: stackTrace,
      metadata: metadata,
    );
  }

  String _uuid() => DateTime.now().microsecondsSinceEpoch.toString();
}
