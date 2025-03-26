import '../../adapted_types/page_controller.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

void registerMethodCommandsForPageController(MethodBindingRegistry registry) {
  registry.registerMethods<AdaptedPageController>({
    'jumpToPage': PageControllerJumpToPageCommand(),
    'animateToPage': PageControllerAnimateToPageCommand(),
    'nextPage': PageControllerNextPageCommand(),
    'previousPage': PageControllerPreviousPageCommand(),
  });
}
