import 'package:digia_expr/digia_expr.dart';

// Implement all methods from ScopeContext
// This is the same implementation as before, but now it's implementing
// the ScopeContext interface
abstract class ScopeContext extends ExprContext {
  /// Creates a new context with additional variables.
  ///
  /// The new context should inherit all variables from this context,
  /// and add or override with the provided newVariables.
  ///
  /// @param newVariables A map of new or updated variables to add to the context.
  /// @return A new ExprContext instance with the combined variables.
  ScopeContext copyAndExtend({required Map<String, Object?> newVariables});
}
