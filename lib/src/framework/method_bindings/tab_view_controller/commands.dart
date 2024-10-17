import '../../internal_widgets/tab_view/controller.dart';
import '../../utils/object_util.dart';
import '../base.dart';

class TabViewControllerAnimateToCommand
    implements MethodCommand<TabViewController> {
  @override
  void run(TabViewController instance, Map<String, Object?> args) {
    int index = args['index']?.to<int>() ?? 0;
    instance.animateTo(index);
  }
}
