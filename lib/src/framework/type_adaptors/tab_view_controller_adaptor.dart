import 'package:digia_expr/digia_expr.dart';

import '../internal_widgets/tab_view/controller.dart';
import 'base.dart';

class TabViewControllerAdaptor implements TypeAdapter<TabViewController> {
  @override
  ExprClassInstance wrap(TabViewController instance) {
    return ExprClassInstance(
        klass: ExprClass(
      name: 'TabViewController',
      fields: {
        'currentIndex': instance.index,
      },
      methods: {},
    ));
  }

  @override
  bool canAdapt(Object? value) => value is TabViewController;
}
