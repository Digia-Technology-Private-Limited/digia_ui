import '../../internal_widgets/tab_view/controller.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

registerMethodCommandsForTabViewController(MethodBindingRegistry registry) {
  registry.registerMethods<TabViewController>({
    'animateTo': TabViewControllerAnimateToCommand(),
  });
}
