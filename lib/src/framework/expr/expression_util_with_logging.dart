// import 'package:digia_expr/digia_expr.dart';
// import 'package:digia_inspector_core/digia_inspector_core.dart';

// import '../../../digia_ui.dart';
// import '../utils/object_util.dart';
// import 'debug_scope_context.dart';
// import 'expression_util.dart';
// import 'scope_context.dart';

// T? evaluateExpressionWithLogging<T extends Object>(
//   String expression,
//   ScopeContext? scopeContext, {
//   bool enableLogging = true,
// }) {
//   if (!enableLogging) {
//     return evaluateExpression<T>(expression, scopeContext);
//   }

//   // Wrap the context to track variable access
//   final loggingContext =
//       scopeContext != null ? DebugScopeContext(scopeContext) : null;

//   // Evaluate the expression
//   final result = Expression.eval(expression, loggingContext);
//   final typedResult = result?.to<T>();

//   // Create and dispatch the log
//   final log = ExpressionEvaluationLog(
//     expression: expression,
//     variables: loggingContext?.accessedVariables ?? {},
//     resolvedValue: typedResult,
//     timestamp: DateTime.now(),
//     contextName: scopeContext?.name,
//   );

//   DigiaUIManager().logger?.log(log);

//   return typedResult;
// }

// T? evaluateWithLogging<T extends Object>(
//   Object? expression, {
//   ScopeContext? scopeContext,
//   T? Function(Object?)? decoder,
//   bool enableLogging = true,
// }) {
//   if (expression == null) return null;

//   if (!hasExpression(expression)) {
//     return decoder?.call(expression) ?? expression.to<T>();
//   }

//   if (!enableLogging) {
//     return evaluate<T>(expression,
//         scopeContext: scopeContext, decoder: decoder);
//   }

//   return evaluateExpressionWithLogging<T>(
//     expression as String,
//     scopeContext,
//     enableLogging: enableLogging,
//   );
// }

// Object? evaluateNestedExpressionsWithLogging(
//   Object? data,
//   ScopeContext? context, {
//   bool enableLogging = true,
// }) {
//   if (data == null) return null;

//   // Evaluate primitive types directly
//   if (data is String || data is num || data is bool) {
//     return evaluateWithLogging(
//       data,
//       scopeContext: context,
//       enableLogging: enableLogging,
//     );
//   }

//   // Recursively evaluate Map entries
//   if (data is Map<String, Object?>) {
//     return data.map((key, value) {
//       var evaluatedKey = evaluateWithLogging<String>(
//             key,
//             scopeContext: context,
//             enableLogging: enableLogging,
//           ) ??
//           key;
//       var evaluatedValue = evaluateNestedExpressionsWithLogging(
//         value,
//         context,
//         enableLogging: enableLogging,
//       );
//       return MapEntry(evaluatedKey, evaluatedValue);
//     });
//   }

//   // Recursively evaluate List elements
//   if (data is List) {
//     return data
//         .map((e) => evaluateNestedExpressionsWithLogging(
//               e,
//               context,
//               enableLogging: enableLogging,
//             ))
//         .toList();
//   }

//   // Return unchanged for unsupported types
//   return data;
// }
