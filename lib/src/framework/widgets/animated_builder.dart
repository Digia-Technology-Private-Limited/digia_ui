import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_animated_builder.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWAnimatedBuilder extends VirtualStatelessWidget<Props> {
  VWAnimatedBuilder({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
    required super.childGroups,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();
    final valueNotifier = payload.eval(props.get('opacity')) as ValueNotifier?;

    return InternalAnimatedBuilder(
      valueNotifier: valueNotifier,
      builder: (innrCtx, value) {
        return child!.toWidget(
            payload.copyWithChainedContext(_createExprContext(value)));
      },
    );
  }

  ScopeContext _createExprContext(Object? value) {
    return DefaultScopeContext(variables: {
      'value': value,
    });
  }
}
