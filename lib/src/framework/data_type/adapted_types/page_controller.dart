import 'package:digia_expr/digia_expr.dart';

import 'package:flutter/widgets.dart';

class AdaptedPageController extends PageController implements ExprInstance {
  AdaptedPageController(
      {super.initialPage, super.viewportFraction, super.keepPage});
  @override
  Object? getField(String name) => switch (name) {
        'offset' => offset,
        'page' => page,
        _ => null,
      };
}
