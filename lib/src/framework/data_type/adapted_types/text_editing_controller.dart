import 'package:digia_expr/digia_expr.dart';

import 'package:flutter/widgets.dart';

class AdaptedTextEditingController extends TextEditingController
    implements ExprInstance {
  AdaptedTextEditingController({super.text});

  @override
  Object? getField(String name) => switch (name) {
        'text' => text,
        _ => null,
      };
}
