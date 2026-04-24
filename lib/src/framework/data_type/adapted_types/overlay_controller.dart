import 'package:digia_expr/digia_expr.dart';

import '../../internal_widgets/internal_overlay.dart';

class AdaptedOverlayController extends DSOverlayController
    implements ExprInstance {
  AdaptedOverlayController();

  @override
  Object? getField(String name) => switch (name) {
        'isVisible' => isVisible,
        _ => null,
      };
}
