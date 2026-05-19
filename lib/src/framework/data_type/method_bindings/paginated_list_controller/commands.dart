import '../../../internal_widgets/paginated_list_controller.dart';
import '../base.dart';

class PaginatedListControllerInvalidateCommand
    implements MethodCommand<PaginatedListController> {
  @override
  void run(PaginatedListController instance, Map<String, Object?> args) {
    instance.invalidate();
  }
}
