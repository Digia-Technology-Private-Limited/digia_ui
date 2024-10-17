import 'package:digia_expr/digia_expr.dart';

import 'package:flutter/widgets.dart';

import 'base.dart';

class ScrollControllerAdapter implements TypeAdapter<ScrollController> {
  @override
  ExprClassInstance wrap(ScrollController instance) {
    return ExprClassInstance(
        klass: ExprClass(
      name: 'ScrollController',
      fields: {
        'offset': instance.offset,
      },
      methods: {},
    ));
  }

  @override
  bool canAdapt(Object? value) => value is ScrollController;
}
