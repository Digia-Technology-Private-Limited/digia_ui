import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../../models/props.dart';
import '../../models/types.dart';
import '../../page/resource_provider.dart';
import '../../render_payload.dart';
import '../../utils/flutter_type_converters.dart';
import '../../utils/functional_util.dart';
import '../../utils/navigation_util.dart';
import '../../utils/types.dart';
import '../../widgets/icon.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class ShowBottomSheetProcessor
    implements ActionProcessor<ShowBottomSheetAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ExprContext? exprContext,
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
    ExprContext? exprContext,
  ) async {
    final pageId = action.pageId;
    if (pageId == null) {
      throw ArgumentError('Null value', 'pageId');
    }

    final JsonLike style = action.style ?? {};
    final provider = ResourceProvider.maybeOf(context);
    final navigatorKey = provider?.navigatorKey;
    final bgColor = ExprOr.fromJson<String>(style['bgColor'])
        ?.evaluate(exprContext)
        .maybe((p0) => provider?.getColor(p0));
    final barrierColor = ExprOr.fromJson<String>(style['barrierColor'])
        ?.evaluate(exprContext)
        .maybe((p0) => provider?.getColor(p0));
    final borderColor = ExprOr.fromJson<String>(style['borderColor'])
        ?.evaluate(exprContext)
        .maybe((p0) => provider?.getColor(p0));
    final maxHeightRatio =
        ExprOr.fromJson<double>(style['maxHeight'])?.evaluate(exprContext) ?? 1;

    final iconProps = as$<JsonLike>(style['icon']).maybe((p0) => Props(p0));

    Object? result = await presentBottomSheet(
        context: navigatorKey?.currentContext ?? context,
        builder: (innerCtx) => viewBuilder(
              innerCtx,
              pageId,
              action.pageArgs,
            ),
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
                  buildContext: innerCtx,
                  exprContext: ExprContext(
                    variables: {},
                    enclosing: exprContext,
                  ),
                ),
              );
        }));

    if (action.waitForResult && context.mounted) {
      await executeActionFlow(
        context,
        action.onResult ?? ActionFlow.empty(),
        ExprContext(variables: {
          'result': result,
        }, enclosing: exprContext),
      );
    }

    return null;
  }
}
