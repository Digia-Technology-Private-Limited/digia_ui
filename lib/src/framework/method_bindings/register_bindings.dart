import 'method_binding_registry.dart';
import 'scroll_controller/register_fn.dart';

void registerBindings(MethodBindingRegistry registry) {
  registerMethodCommandsForScrollController(registry);
}
