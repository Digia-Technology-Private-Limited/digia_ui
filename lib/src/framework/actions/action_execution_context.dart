import 'package:digia_inspector_core/digia_inspector_core.dart';

import 'action_descriptor.dart';
import 'base/action.dart';

class ActionExecutionContext {
  final ActionObserver? actionObserver;

  ActionExecutionContext({
    this.actionObserver,
  });

  void notifyPending({
    required String id,
    String? parentActionId,
    required ActionType type,
    required Map<String, dynamic> definition,
    ObservabilityContext? observabilityContext,
  }) {
    final log = _makeLog(
      status: ActionStatus.pending,
      id: id,
      parentActionId: parentActionId,
      actionDefinition: definition,
      actionType: type,
      observabilityContext: observabilityContext,
    );
    actionObserver?.onActionPending(log);
  }

  void notifyStart({
    required String id,
    String? parentActionId,
    required ActionDescriptor descriptor,
    ObservabilityContext? observabilityContext,
  }) {
    final log = _makeLog(
      status: ActionStatus.running,
      id: id,
      parentActionId: parentActionId,
      actionDefinition: descriptor.definition,
      resolvedParameters: descriptor.resolvedParameters,
      actionType: descriptor.type,
      observabilityContext: observabilityContext,
    );
    actionObserver?.onActionStart(log);
  }

  void notifyProgress({
    required String id,
    String? parentActionId,
    required ActionDescriptor descriptor,
    required Map<String, dynamic> details,
    ObservabilityContext? observabilityContext,
  }) {
    final log = _makeLog(
      status: ActionStatus.running,
      id: id,
      parentActionId: parentActionId,
      actionDefinition: descriptor.definition,
      actionType: descriptor.type,
      resolvedParameters: descriptor.resolvedParameters,
      progressData: details,
      observabilityContext: observabilityContext,
    );
    actionObserver?.onActionProgress(log);
  }

  void notifyComplete({
    required String id,
    String? parentActionId,
    required ActionDescriptor descriptor,
    required Object? error,
    required StackTrace? stackTrace,
    ObservabilityContext? observabilityContext,
  }) {
    final status = error == null ? ActionStatus.completed : ActionStatus.error;
    final log = _makeLog(
      status: status,
      id: id,
      parentActionId: parentActionId,
      error: error,
      resolvedParameters: descriptor.resolvedParameters,
      stackTrace: stackTrace,
      actionDefinition: descriptor.definition,
      actionType: descriptor.type,
      observabilityContext: observabilityContext,
    );
    actionObserver?.onActionComplete(log);
  }

  void notifyDisabled({
    required String id,
    String? parentActionId,
    required ActionDescriptor descriptor,
    required String reason,
    ObservabilityContext? observabilityContext,
  }) {
    final log = _makeLog(
      status: ActionStatus.disabled,
      id: id,
      parentActionId: parentActionId,
      actionDefinition: descriptor.definition,
      resolvedParameters: descriptor.resolvedParameters,
      metadata: {'reason': reason},
      actionType: descriptor.type,
      observabilityContext: observabilityContext,
    );
    actionObserver?.onActionDisabled(log);
  }

  ActionLog _makeLog({
    required ActionStatus status,
    required ActionType? actionType,
    ObservabilityContext? observabilityContext,
    Map<String, dynamic>? actionDefinition,
    Map<String, dynamic>? resolvedParameters,
    String? id,
    String? parentActionId,
    Map<String, dynamic>? progressData,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic> metadata = const {},
  }) {
    final now = DateTime.now().toUtc();
    return ActionLog(
      id: id ?? IdHelper.randomId(),
      category: 'action',
      actionType: actionType?.value ?? 'unknown',
      status: status,
      timestamp: now,
      executionTime: null,
      parentActionId: parentActionId,
      sourceChain: observabilityContext?.sourceChain,
      triggerName: observabilityContext?.triggerType,
      actionDefinition: actionDefinition ?? const {},
      resolvedParameters: resolvedParameters ?? const {},
      progressData: progressData,
      error: error,
      errorMessage: error?.toString(),
      stackTrace: stackTrace,
    );
  }
}
