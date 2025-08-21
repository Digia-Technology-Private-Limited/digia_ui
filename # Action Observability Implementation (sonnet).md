# Action Observability Implementation Plan

## Overview
This plan outlines the implementation of comprehensive action observability for Digia UI SDK, enabling real-time tracking of action execution in Dashboard/Console with minimal performance impact.

## Architecture

### Core Components
1. **ActionObserver** - Main observability interface injected via DigiaUIOptions
2. **ActionEvent** - Data structure for action execution events
3. **ObservabilityContext** - Widget hierarchy and metadata
4. **ActionEventStream** - Real-time event streaming to Dashboard/Console

### Integration Points
- `DigiaUIOptions` - Logger injection point
- `ActionExecutor` - Primary instrumentation point
- `ActionProcessor` - Individual action tracking
- `VirtualWidget` - Hierarchy context capture

## Data Structures

### ActionEvent
```dart
class ActionEvent {
  final String eventId;           // Unique identifier for this event instance
  final String actionId;          // Action identifier in the chain
  final String actionType;        // Type of action (callRestApi, navigateToPage, etc.)
  final ActionStatus status;      // pending, running, completed, error, disabled
  final DateTime timestamp;       // When the event occurred
  final Duration? executionTime;  // Total execution time (null if still running)
  
  // Hierarchy Information
  final String? parentEventId;    // Parent action event ID (for nesting)
  final List<String> sourceChain; // Widget hierarchy (Page -> Component -> Widget -> trigger)
  final String triggerName;       // onClick, onPageLoad, etc.
  
  // Action Details
  final Map<String, dynamic> actionDefinition; // Original action JSON
  final Map<String, dynamic>? resolvedParameters; // Parameters after expression evaluation
  final Map<String, dynamic>? progressData; // Progress information for long-running actions
  
  // Expression Tracking
  final List<ExpressionEvaluation>? expressions; // Expression evaluation details
  
  // Error Information
  final dynamic error;            // Error object if status is error
  final String? errorMessage;     // Human-readable error message
  final String? stackTrace;       // Stack trace for debugging
  
  // Metadata
  final Map<String, dynamic>? metadata; // Additional context
}

enum ActionStatus {
  pending,    // Action queued but not started
  running,    // Action currently executing
  completed,  // Action completed successfully
  error,      // Action failed with error
  disabled,   // Action skipped due to disableActionIf condition
}

class ExpressionEvaluation {
  final String expression;        // Original expression string
  final dynamic resolvedValue;    // Evaluated result
  final Map<String, dynamic> availableVariables; // Context during evaluation
  final String? error;            // Error if evaluation failed
  final String evaluationPoint;   // Where evaluation occurred (parameter, condition, etc.)
}
```

### ObservabilityContext
```dart
class ObservabilityContext {
  final List<String> widgetHierarchy; // Page -> Component -> Widget path
  final String currentPageId;         // Current page identifier
  final String? currentComponentId;   // Current component identifier (if applicable)
  final String triggerWidgetId;       // Widget that triggered the action
  final String triggerType;           // onClick, onTap, onPageLoad, etc.
  
  // Helper method to create source chain
  List<String> get sourceChain => [...widgetHierarchy, triggerType];
}
```

### ActionObserver Interface
```dart
abstract class ActionObserver {
  /// Called when an action starts execution
  void onActionStart(ActionEvent event);
  
  /// Called when action progress updates (for long-running actions)
  void onActionProgress(ActionEvent event);
  
  /// Called when action completes or fails
  void onActionComplete(ActionEvent event);
  
  /// Called when action is disabled/skipped
  void onActionDisabled(ActionEvent event);
}

// Implementation for Console/Dashboard
class StreamActionObserver implements ActionObserver {
  final StreamController<ActionEvent> _controller = StreamController.broadcast();
  
  Stream<ActionEvent> get eventStream => _controller.stream;
  
  @override
  void onActionStart(ActionEvent event) => _controller.add(event);
  
  @override
  void onActionProgress(ActionEvent event) => _controller.add(event);
  
  @override
  void onActionComplete(ActionEvent event) => _controller.add(event);
  
  @override
  void onActionDisabled(ActionEvent event) => _controller.add(event);
}
```

## Implementation Strategy

### 1. Conditional Compilation
Use assert statements and kDebugMode to exclude from release builds:

```dart
// observability_stub.dart - Empty implementations for release
class ActionObserver {
  void onActionStart(ActionEvent event) {}
  void onActionProgress(ActionEvent event) {}
  void onActionComplete(ActionEvent event) {}
  void onActionDisabled(ActionEvent event) {}
}

// observability_impl.dart - Full implementation for debug
class ActionObserver {
  // Full implementation here
}

// Import strategy
import 'observability_stub.dart' if (dart.library.developer) 'observability_impl.dart';
```

### 2. DigiaUIOptions Integration
```dart
class DigiaUIOptions {
  final String accessKey;
  final Flavor flavor;
  final NetworkConfiguration? networkConfiguration;
  final ActionObserver? actionObserver; // NEW: Observability injection
  final bool enableActionObservability;  // NEW: Feature flag
  
  DigiaUIOptions({
    required this.accessKey,
    required this.flavor,
    this.networkConfiguration,
    this.actionObserver,
    this.enableActionObservability = false,
  });
}
```

### 3. ActionExecutor Instrumentation
```dart
class ActionExecutor {
  final ActionObserver? _observer;
  final bool _observabilityEnabled;
  
  ActionExecutor({
    required this.viewBuilder,
    required this.pageRouteBuilder,
    required this.bindingRegistry,
    this.logger,
    this.metaData,
    ActionObserver? observer,
    bool enableObservability = false,
  }) : _observer = observer,
       _observabilityEnabled = enableObservability && observer != null;

  Future<void> executeAction(
    Map<String, dynamic> actionDef,
    ScopeContext scopeContext, {
    ObservabilityContext? observabilityContext,
    String? parentEventId,
  }) async {
    if (!_observabilityEnabled) {
      // Execute without observability
      return _executeActionInternal(actionDef, scopeContext);
    }
    
    final eventId = _generateEventId();
    final actionType = actionDef['type'] as String;
    
    // Check if action should be disabled
    final disableCondition = actionDef['disableActionIf'];
    if (disableCondition != null) {
      final shouldDisable = await _evaluateCondition(disableCondition, scopeContext);
      if (shouldDisable) {
        _observer?.onActionDisabled(ActionEvent(
          eventId: eventId,
          actionId: actionDef['id'] ?? eventId,
          actionType: actionType,
          status: ActionStatus.disabled,
          timestamp: DateTime.now(),
          parentEventId: parentEventId,
          sourceChain: observabilityContext?.sourceChain ?? [],
          triggerName: observabilityContext?.triggerType ?? 'unknown',
          actionDefinition: actionDef,
        ));
        return;
      }
    }
    
    // Evaluate expressions and log them
    final expressionEvaluations = await _evaluateActionExpressions(actionDef, scopeContext);
    final resolvedParameters = _getResolvedParameters(actionDef, scopeContext);
    
    // Start action
    _observer?.onActionStart(ActionEvent(
      eventId: eventId,
      actionId: actionDef['id'] ?? eventId,
      actionType: actionType,
      status: ActionStatus.running,
      timestamp: DateTime.now(),
      parentEventId: parentEventId,
      sourceChain: observabilityContext?.sourceChain ?? [],
      triggerName: observabilityContext?.triggerType ?? 'unknown',
      actionDefinition: actionDef,
      resolvedParameters: resolvedParameters,
      expressions: expressionEvaluations,
    ));
    
    try {
      final startTime = DateTime.now();
      
      // Execute the actual action with progress tracking
      await _executeActionWithProgress(
        actionDef, 
        scopeContext, 
        eventId,
        observabilityContext,
      );
      
      final executionTime = DateTime.now().difference(startTime);
      
      // Complete action
      _observer?.onActionComplete(ActionEvent(
        eventId: eventId,
        actionId: actionDef['id'] ?? eventId,
        actionType: actionType,
        status: ActionStatus.completed,
        timestamp: DateTime.now(),
        executionTime: executionTime,
        parentEventId: parentEventId,
        sourceChain: observabilityContext?.sourceChain ?? [],
        triggerName: observabilityContext?.triggerType ?? 'unknown',
        actionDefinition: actionDef,
        resolvedParameters: resolvedParameters,
        expressions: expressionEvaluations,
      ));
      
    } catch (error, stackTrace) {
      // Error action
      _observer?.onActionComplete(ActionEvent(
        eventId: eventId,
        actionId: actionDef['id'] ?? eventId,
        actionType: actionType,
        status: ActionStatus.error,
        timestamp: DateTime.now(),
        parentEventId: parentEventId,
        sourceChain: observabilityContext?.sourceChain ?? [],
        triggerName: observabilityContext?.triggerType ?? 'unknown',
        actionDefinition: actionDef,
        resolvedParameters: resolvedParameters,
        expressions: expressionEvaluations,
        error: error,
        errorMessage: error.toString(),
        stackTrace: stackTrace.toString(),
      ));
      
      rethrow;
    }
  }
  
  String _generateEventId() => DateTime.now().millisecondsSinceEpoch.toString();
}
```

### 4. Progress Tracking for Long-Running Actions

```dart
// For callRestApi action processor
class CallRestApiProcessor extends ActionProcessor {
  @override
  Future<void> process(
    CallRestApiAction action,
    ScopeContext scopeContext,
    ActionExecutor actionExecutor,
  ) async {
    final observer = actionExecutor._observer;
    final eventId = scopeContext.metadata['currentEventId'];
    
    if (observer != null && eventId != null) {
      // Request started
      observer.onActionProgress(ActionEvent(
        eventId: eventId,
        actionId: action.id,
        actionType: 'callRestApi',
        status: ActionStatus.running,
        timestamp: DateTime.now(),
        progressData: {
          'phase': 'request_started',
          'url': action.url,
          'method': action.method,
        },
        // ... other fields
      ));
    }
    
    try {
      final response = await _makeHttpRequest(action);
      
      if (observer != null && eventId != null) {
        // Response received
        observer.onActionProgress(ActionEvent(
          eventId: eventId,
          actionId: action.id,
          actionType: 'callRestApi',
          status: ActionStatus.running,
          timestamp: DateTime.now(),
          progressData: {
            'phase': 'response_received',
            'statusCode': response.statusCode,
            'responseSize': response.data?.toString().length ?? 0,
          },
          // ... other fields
        ));
      }
      
      // Execute nested actions (onSuccess, onError)
      if (response.statusCode >= 200 && response.statusCode < 300 && action.onSuccess != null) {
        await _executeNestedActions(action.onSuccess!, scopeContext, actionExecutor, eventId);
      } else if (action.onError != null) {
        await _executeNestedActions(action.onError!, scopeContext, actionExecutor, eventId);
      }
      
    } catch (error) {
      if (observer != null && eventId != null) {
        observer.onActionProgress(ActionEvent(
          eventId: eventId,
          actionId: action.id,
          actionType: 'callRestApi',
          status: ActionStatus.error,
          timestamp: DateTime.now(),
          progressData: {
            'phase': 'request_failed',
            'error': error.toString(),
          },
          error: error,
          // ... other fields
        ));
      }
      rethrow;
    }
  }
  
  Future<void> _executeNestedActions(
    List<Map<String, dynamic>> actions,
    ScopeContext scopeContext,
    ActionExecutor actionExecutor,
    String parentEventId,
  ) async {
    for (final actionDef in actions) {
      await actionExecutor.executeAction(
        actionDef,
        scopeContext,
        parentEventId: parentEventId,
      );
    }
  }
}
```

### 5. VirtualWidget Integration

```dart
abstract class VirtualWidget {
  final String? refName;
  final WeakReference<VirtualWidget>? _parent;
  final String? _observabilityId; // NEW: For tracking hierarchy

  VirtualWidget({
    required this.refName,
    required VirtualWidget? parent,
    String? observabilityId,
  }) : _parent = parent != null ? WeakReference(parent) : null,
       _observabilityId = observabilityId;

  Widget render(RenderPayload payload);
  
  // NEW: Helper to build observability context
  ObservabilityContext _buildObservabilityContext(String triggerType) {
    final hierarchy = <String>[];
    VirtualWidget? current = this;
    
    // Build hierarchy from current widget up to root
    while (current != null) {
      if (current.refName != null) {
        hierarchy.insert(0, current.refName!);
      }
      current = current.parent;
    }
    
    return ObservabilityContext(
      widgetHierarchy: hierarchy,
      currentPageId: _findPageId(),
      currentComponentId: _findComponentId(),
      triggerWidgetId: refName ?? 'unknown',
      triggerType: triggerType,
    );
  }
}

// Example usage in a Button widget
class ButtonWidget extends VirtualWidget<ButtonProps> {
  @override
  Widget render(RenderPayload payload) {
    return ElevatedButton(
      onPressed: props.onTap != null ? () {
        final context = _buildObservabilityContext('onTap');
        
        DefaultActionExecutor.of(payload.context).executeAction(
          props.onTap!,
          payload.scopeContext,
          observabilityContext: context,
        );
      } : null,
      child: Text(props.text),
    );
  }
}
```

## Dashboard Integration

### Console Implementation
```dart
class ActionConsole extends StatefulWidget {
  final Stream<ActionEvent> actionStream;
  
  const ActionConsole({required this.actionStream});
  
  @override
  State<ActionConsole> createState() => _ActionConsoleState();
}

class _ActionConsoleState extends State<ActionConsole> {
  final List<ActionEvent> _events = [];
  final Map<String, ActionEvent> _activeEvents = {}; // Track ongoing actions
  
  @override
  void initState() {
    super.initState();
    widget.actionStream.listen(_handleActionEvent);
  }
  
  void _handleActionEvent(ActionEvent event) {
    setState(() {
      if (event.status == ActionStatus.running) {
        // Update existing event or add new one
        _activeEvents[event.eventId] = event;
        
        // Add to timeline if it's a new action
        if (!_events.any((e) => e.eventId == event.eventId)) {
          _events.add(event);
        } else {
          // Update existing event in timeline
          final index = _events.indexWhere((e) => e.eventId == event.eventId);
          if (index != -1) {
            _events[index] = event;
          }
        }
      } else {
        // Action completed/failed/disabled
        _activeEvents.remove(event.eventId);
        
        // Update in timeline
        final index = _events.indexWhere((e) => e.eventId == event.eventId);
        if (index != -1) {
          _events[index] = event;
        } else {
          _events.add(event);
        }
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Timeline view
        Expanded(
          child: ListView.builder(
            itemCount: _events.length,
            itemBuilder: (context, index) {
              final event = _events[index];
              return ActionEventTile(
                event: event,
                isNested: event.parentEventId != null,
              );
            },
          ),
        ),
        
        // Controls (clear history, filters, etc.)
        ActionConsoleControls(
          onClearHistory: () => setState(() => _events.clear()),
          onFilterChanged: _handleFilterChanged,
        ),
      ],
    );
  }
}

class ActionEventTile extends StatelessWidget {
  final ActionEvent event;
  final bool isNested;
  
  const ActionEventTile({
    required this.event,
    this.isNested = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(event.status);
    final indent = isNested ? 20.0 : 0.0;
    
    return Container(
      margin: EdgeInsets.only(left: indent),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          radius: 8,
        ),
        title: Text('${event.actionType} (${event.actionId})'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Source: ${event.sourceChain.join(' → ')}'),
            if (event.executionTime != null)
              Text('Duration: ${event.executionTime!.inMilliseconds}ms'),
            if (event.progressData != null)
              Text('Progress: ${event.progressData!['phase'] ?? 'Unknown'}'),
            if (event.error != null)
              Text('Error: ${event.errorMessage}', style: TextStyle(color: Colors.red)),
          ],
        ),
        trailing: Text(
          event.timestamp.toString().substring(11, 19), // Time only
        ),
        onTap: () => _showEventDetails(context, event),
      ),
    );
  }
  
  Color _getStatusColor(ActionStatus status) {
    switch (status) {
      case ActionStatus.completed:
        return Colors.green;
      case ActionStatus.error:
        return Colors.red;
      case ActionStatus.disabled:
        return Colors.yellow;
      case ActionStatus.running:
      case ActionStatus.pending:
        return Colors.blue;
    }
  }
}
```

## Testing Strategy

### Unit Test Support
```dart
class MockActionObserver implements ActionObserver {
  final List<ActionEvent> events = [];
  
  @override
  void onActionStart(ActionEvent event) => events.add(event);
  
  @override
  void onActionProgress(ActionEvent event) => events.add(event);
  
  @override
  void onActionComplete(ActionEvent event) => events.add(event);
  
  @override
  void onActionDisabled(ActionEvent event) => events.add(event);
  
  // Test utilities
  List<ActionEvent> getEventsForAction(String actionId) =>
      events.where((e) => e.actionId == actionId).toList();
      
  ActionEvent? getLastEventForAction(String actionId) =>
      events.where((e) => e.actionId == actionId).lastOrNull;
}

// Test example
testWidgets('Action observability tracks button tap', (tester) async {
  final mockObserver = MockActionObserver();
  
  await tester.pumpWidget(
    DigiaUIApp(
      digiaUI: await DigiaUI.initialize(
        DigiaUIOptions(
          accessKey: 'test',
          flavor: Flavor.debug(),
          actionObserver: mockObserver,
          enableActionObservability: true,
        ),
      ),
      builder: (context) => MaterialApp(
        home: DUIFactory().createPage('test_page', {}),
      ),
    ),
  );
  
  // Tap button
  await tester.tap(find.text('Test Button'));
  await tester.pump();
  
  // Verify events
  expect(mockObserver.events.length, 2); // Start and complete
  expect(mockObserver.events.first.status, ActionStatus.running);
  expect(mockObserver.events.last.status, ActionStatus.completed);
});
```

## Implementation Timeline

### Phase 1: Core Infrastructure (Week 1-2)
1. Create data structures (ActionEvent, ObservabilityContext, ActionObserver)
2. Implement conditional compilation strategy
3. Add observability injection to DigiaUIOptions
4. Modify ActionExecutor for basic tracking

### Phase 2: Action Integration (Week 2-3)
1. Instrument individual action processors
2. Implement progress tracking for long-running actions
3. Add expression evaluation logging
4. Handle nested action tracking

### Phase 3: Widget Hierarchy (Week 3-4)
1. Modify VirtualWidget base class
2. Implement hierarchy context building
3. Update all widget implementations
4. Test source chain accuracy

### Phase 4: Console & Testing (Week 4-5)
1. Create Console UI components
2. Implement filtering and search
3. Add comprehensive unit tests
4. Performance testing and optimization

## Performance Considerations

1. **Conditional Compilation**: Entire observability system excluded from release builds
2. **Lazy Evaluation**: Context building only when observability is enabled
3. **Efficient Streaming**: Use broadcast streams to support multiple listeners
4. **Memory Management**: Events stored outside DigiaUI in Console
5. **Async Operations**: Non-blocking event emission where possible

## Future Enhancements

1. **Action Replay**: Ability to replay action sequences for debugging
2. **Breakpoints**: Pause action execution for inspection
3. **State Snapshots**: Capture state at various execution points
4. **Performance Metrics**: Track action execution performance over time
5. **Advanced Filtering**: Complex query capabilities for large event histories