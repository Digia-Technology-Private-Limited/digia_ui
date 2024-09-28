import 'package:flutter/material.dart';
import '../../../Utils/basic_shared_utils/lodash.dart';
import '../../base/virtual_stateless_widget.dart';
import '../../internal_widgets/tab_view/tab_view_controller_scope_widget.dart';
import '../../render_payload.dart';
import '../../widget_props/tab_view_controller_props.dart';

class VWTabViewController
    extends VirtualStatelessWidget<TabViewControllerProps> {
  VWTabViewController({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    final tabs = payload.evalExpr<List>(
          props.tabs,
          decoder: (p0) {
            if (p0 == null) return null;

            if (p0 is List) return p0;

            if (p0 is! String) return null;

            final parsed = tryJsonDecode(p0);
            if (parsed is List) return parsed;
            return null;
          },
        ) ??
        [];
    final initialIndex = payload.evalExpr<int>(props.initialIndex) ?? 0;

    return TabViewControllerScopeWidget(
      tabs: tabs,
      initialIndex: initialIndex,
      childBuilder: (innerCtx) {
        final updatedPayload = payload.copyWith(buildContext: innerCtx);
        return child!.toWidget(updatedPayload);
      },
    );
  }
}
