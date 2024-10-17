import 'dart:async';

import 'package:digia_expr/digia_expr.dart';

import 'base.dart';

class StreamControllerAdapter implements TypeAdapter<StreamController> {
  @override
  ExprClassInstance wrap(StreamController instance) {
    return ExprClassInstance(
        klass: ExprClass(
      name: 'StreamController',
      fields: {
        'isClosed': instance.isClosed,
        'isPaused': instance.isPaused,
      },
      methods: {},
    ));
  }

  @override
  bool canAdapt(Object? value) => value is StreamController;
}
