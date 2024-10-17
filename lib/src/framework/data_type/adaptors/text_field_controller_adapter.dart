import 'package:digia_expr/digia_expr.dart';

import 'package:flutter/widgets.dart';

import 'base.dart';

class TextEditingControllerAdapter
    implements TypeAdapter<TextEditingController> {
  @override
  ExprClassInstance wrap(TextEditingController instance) {
    return ExprClassInstance(
        klass: ExprClass(
      name: 'TextFieldController',
      fields: {
        'text': instance.text,
      },
      methods: {},
    ));
  }

  @override
  bool canAdapt(Object? value) => value is TextEditingController;
}
