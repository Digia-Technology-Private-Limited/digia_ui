import 'package:digia_expr/digia_expr.dart';

import 'package:scroll_to_index/scroll_to_index.dart';

class AdaptedScrollController extends SimpleAutoScrollController
    implements ExprInstance {
  AdaptedScrollController()
      : super(
          beginGetter: (rect) => rect.left,
          endGetter: (rect) => rect.right,
        );

  @override
  Object? getField(String name) => switch (name) {
        'offset' => offset,
        _ => null,
      };
}
