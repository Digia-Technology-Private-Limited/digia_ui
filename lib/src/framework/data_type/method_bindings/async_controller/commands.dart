import '../../../internal_widgets/async_builder/controller.dart';

import '../base.dart';

class AsyncControllerInvalidateCommand
    implements MethodCommand<AsyncController<Object?>> {
  @override
  void run(AsyncController<Object?> instance, Map<String, Object?> args) {
    instance.invalidate();
  }
}
