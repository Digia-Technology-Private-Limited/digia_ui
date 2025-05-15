/// Observer for monitoring state changes in StateContext hierarchy.
/// Tracks state changes at page/component level scope.
abstract class StateObserver {
  /// Called when a new page/component scope is created.
  /// [nameSpace] identifies the specific page/component scope being created.
  void onCreate(String nameSpace) {}

  /// Called when a page/component scope is disposed.
  /// Triggered when navigating away from a page or disposing a component.
  void onDispose() {}

  /// Called whenever state values change within a specific page/component scope.
  /// [nameSpace] identifies the page/component where the change occurred.
  /// [nextState] contains the new state values after the change.
  /// [currentState] contains the state values before the change.
  void onStateChange(
    String nameSpace,
    Map<String, Object?> nextState,
    Map<String, Object?> currentState,
  ) {}
}
