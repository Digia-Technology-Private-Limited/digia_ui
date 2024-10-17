import 'package:digia_expr/digia_expr.dart';

import '../../internal_widgets/timer/controller.dart';
import 'base.dart';

class TimerControllerAdaptor implements TypeAdapter<TimerController> {
  @override
  ExprClassInstance wrap(TimerController instance) {
    return ExprClassInstance(
        klass: ExprClass(
      name: 'TimerController',
      fields: {
        'currentValue': instance.currentValue,
      },
      methods: {},
    ));
  }

  @override
  bool canAdapt(Object? value) => value is TimerController;
}
