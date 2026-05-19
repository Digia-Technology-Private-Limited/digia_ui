import '../../../internal_widgets/paginated_list_controller.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

void registerMethodCommandsForPaginatedListController(
    MethodBindingRegistry registry) {
  registry.registerMethods<PaginatedListController>({
    'invalidate': PaginatedListControllerInvalidateCommand(),
  });
}
