import 'package:flutter/widgets.dart';

import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../models/types.dart';
import '../../render_payload.dart';
import '../../resource_provider.dart';
import '../../utils/flutter_type_converters.dart';
import '../../utils/functional_util.dart';
import '../../utils/navigation_util.dart';
import '../../utils/types.dart';
import '../../widget_props/icon_props.dart';
import '../../widgets/icon.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class ShowBottomSheetProcessor extends ActionProcessor<ShowBottomSheetAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext,
  ) executeActionFlow;

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
    ScopeContext? scopeContext,
  ) async {
    final JsonLike style = action.style ?? {};
    final provider = ResourceProvider.maybeOf(context);
    final navigatorKey = provider?.navigatorKey;
    final bgColor = ExprOr.fromJson<String>(style['bgColor'])
        ?.evaluate(scopeContext)
        .maybe((p0) => provider?.getColor(p0));
    final barrierColor = ExprOr.fromJson<String>(style['barrierColor'])
        ?.evaluate(scopeContext)
        .maybe((p0) => provider?.getColor(p0));
    final borderColor = ExprOr.fromJson<String>(style['borderColor'])
        ?.evaluate(scopeContext)
        .maybe((p0) => provider?.getColor(p0));
    final maxHeightRatio =
        ExprOr.fromJson<double>(style['maxHeight'])?.evaluate(scopeContext) ??
            1;

    final iconProps = as$<JsonLike>(style['icon']).maybe(IconProps.fromJson);

    logAction(
      action.actionType.value,
      {
        'viewData': action.viewData?.toJson(),
        'style': style,
        'onResult': action.onResult?.actions
            .map((a) => a.actionType.value)
            .toList()
            .toString(),
      },
    );

    Object? result = await presentBottomSheet(
        context: navigatorKey?.currentContext ?? context,
        builder: (innerCtx) {
          return viewBuilder(
            innerCtx,
            as$<String>(as$<JsonLike>(action.viewData)?['viewId']) ?? '',
            as$<JsonLike>(as$<JsonLike>(action.viewData)?['args'])
                ?.map((key, value) => MapEntry(
                      key,
                      ExprOr.fromJson<Object>(value),
                    )),
          );
        },
        navigatorKey: navigatorKey,
        backgroundColor: bgColor,
        scrollControlDisabledMaxHeightRatio: maxHeightRatio,
        barrierColor: barrierColor,
        border: To.border((
          style: as$<String>(style['borderStyle']),
          width: as$<double>(style['borderWidth']),
          color: borderColor,
        )),
        borderRadius: To.borderRadius(style['borderRadius']),
        iconBuilder: iconProps.maybe((p0) {
          return (innerCtx) => VWIcon(
                props: p0,
                commonProps: null,
                parent: null,
              ).toWidget(
                RenderPayload(
                  buildContext: context,
                  scopeContext: DefaultScopeContext(
                    variables: {},
                    enclosing: scopeContext,
                  ),
                ),
              );
        }));

    if (action.waitForResult && context.mounted) {
      logAction(
        '${action.actionType.value} - Result',
        {
          'viewData': action.viewData?.toJson(),
          'result': result,
        },
      );
      await executeActionFlow(
        context,
        action.onResult ?? ActionFlow.empty(),
        DefaultScopeContext(variables: {
          'result': result,
        }, enclosing: scopeContext),
      );
    }

    return null;
  }
}
