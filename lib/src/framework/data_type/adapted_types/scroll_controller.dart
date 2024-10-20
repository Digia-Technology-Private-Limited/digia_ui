import 'package:digia_expr/digia_expr.dart';

import 'package:flutter/widgets.dart';

class AdaptedScrollController extends ScrollController implements ExprInstance {
  @override
  Object? getField(String name) => switch (name) {
        'offset' => offset,
        _ => null,
      };
}
