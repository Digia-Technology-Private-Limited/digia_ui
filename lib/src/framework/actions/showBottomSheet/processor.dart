import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../../custom/custom_flutter_types.dart';
import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../models/types.dart';
import '../../resource_provider.dart';
import '../../utils/flutter_type_converters.dart';
import '../../utils/functional_util.dart';
import '../../utils/navigation_util.dart';
import '../../utils/types.dart';
import '../action_descriptor.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class ShowBottomSheetProcessor extends ActionProcessor<ShowBottomSheetAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) executeActionFlow;

  final Widget Function(
    BuildContext context,
    String id,
    JsonLike? args,
  ) viewBuilder;

  ShowBottomSheetProcessor({
    required this.executeActionFlow,
    required this.viewBuilder,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    ShowBottomSheetAction action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final JsonLike style = action.style ?? {};
    final provider = ResourceProvider.maybeOf(context);
    final navigatorKey = provider?.navigatorKey;
    final bgColor = ExprOr.fromJson<String>(style['bgColor'])
        ?.evaluate(scopeContext)
        .maybe((p0) => provider?.getColor(p0, context));
    final barrierColor = ExprOr.fromJson<String>(style['barrierColor'])
        ?.evaluate(scopeContext)
        .maybe((p0) => provider?.getColor(p0, context));
    final borderColor = ExprOr.fromJson<String>(style['borderColor'])
        ?.evaluate(scopeContext)
        .maybe((p0) => provider?.getColor(p0, context));
    final maxHeightRatio =
        ExprOr.fromJson<double>(style['maxHeight'])?.evaluate(scopeContext) ??
            1;
    final useSafeArea = as$<bool>(style['useSafeArea']) ?? true;

    final viewData = action.viewData?.deepEvaluate(scopeContext);
    final evaluatedArgs = as$<JsonLike>(as$<JsonLike>(viewData)?['args']);
    final bottomSheetId = as$<String>(as$<JsonLike>(viewData)?['id']);

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'id': bottomSheetId,
        'args': evaluatedArgs,
        'style': style,
        'waitForResult': action.waitForResult,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      observabilityContext: observabilityContext,
    );

    executionContext?.notifyProgress(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      details: {
        'id': bottomSheetId,
        'args': evaluatedArgs,
        'style': style,
        'waitForResult': action.waitForResult,
      },
      observabilityContext: observabilityContext,
    );

    try {
      final future = presentBottomSheet(
        context: navigatorKey?.currentContext ?? context,
        builder: (innerCtx) {
          return viewBuilder(
            innerCtx,
            bottomSheetId ?? '',
            evaluatedArgs,
          );
        },
        navigatorKey: navigatorKey,
        backgroundColor: bgColor,
        scrollControlDisabledMaxHeightRatio: maxHeightRatio,
        barrierColor: barrierColor,
        useSafeArea: useSafeArea,
        border: To.border((
          style: as$<String>(style['borderStyle']),
          width: as$<double>(style['borderWidth']),
          color: borderColor,
          strokeAlign: To.strokeAlign(as$<String>(style['strokeAlign'])) ??
              StrokeAlign.center,
        )),
        borderRadius: To.borderRadius(style['borderRadius']),
      );

      executionContext?.notifyProgress(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        details: {
          'stage': 'bottom_sheet_presented',
          'id': bottomSheetId,
          'success': true,
          'navigatorKeyExists': navigatorKey != null,
        },
        observabilityContext: observabilityContext,
      );

      Object? result = await future;

      if (action.waitForResult && context.mounted) {
        final onResultContext = observabilityContext?.forTrigger(
            triggerType: 'onBottomSheetResult');

        await executeActionFlow(
          context,
          action.onResult ?? ActionFlow.empty(),
          DefaultScopeContext(variables: {
            'result': result,
          }, enclosing: scopeContext),
          parentActionId: parentActionId,
          id: id,
          observabilityContext: onResultContext,
        );
      }

      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: null,
        stackTrace: null,
        observabilityContext: observabilityContext,
      );

      return null;
    } catch (error) {
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: error,
        stackTrace: StackTrace.current,
        observabilityContext: observabilityContext,
      );

      rethrow;
    }
  }
}
