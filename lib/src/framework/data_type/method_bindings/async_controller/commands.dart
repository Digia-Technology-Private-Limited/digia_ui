import '../../../internal_widgets/async_builder/controller.dart';

import '../base.dart';

class AsyncControllerInvalidateCommand
    implements MethodCommand<AsyncController> {
  @override
  void run(AsyncController instance, Map<String, Object?> args) {
    instance.invalidate();
  }
}
