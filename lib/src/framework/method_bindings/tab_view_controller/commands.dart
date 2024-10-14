import '../../internal_widgets/tab_view/controller.dart';
import '../../utils/object_util.dart';
import '../base.dart';

class TabViewControllerAnimateToCommand
    implements MethodCommand<TabViewController> {
  @override
  void run(TabViewController instance, List<Object?> args) {
    int value = args[0]?.to<int>() ?? 0;
    instance.animateTo(value);
  }
}
