import 'package:digia_expr/digia_expr.dart';

import 'package:flutter/widgets.dart';

import 'base.dart';

class TextFieldControllerAdapter implements TypeAdapter<TextEditingController> {
  @override
  ExprClassInstance wrap(TextEditingController instance) {
    return ExprClassInstance(
        klass: ExprClass(
      name: 'TextFieldController',
      fields: {
        'value': instance.text,
      },
      methods: {},
    ));
  }

  @override
  bool canAdapt(Object? value) => value is TextEditingController;
}
