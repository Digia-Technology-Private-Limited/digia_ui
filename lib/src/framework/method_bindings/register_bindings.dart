import 'async_controller/register_fn.dart';
import 'method_binding_registry.dart';
import 'scroll_controller/register_fn.dart';
import 'stream_controller/register_fn.dart';
import 'tab_view_controller/register_fn.dart';
import 'text_field_controller/register_fn.dart';
import 'timer_controller/register_fn.dart';

void registerBindings(MethodBindingRegistry registry) {
  registerMethodCommandsForScrollController(registry);
  registerMethodCommandsForStreamController(registry);
  registerMethodCommandsForTabViewController(registry);
  registerMethodCommandsForTimerController(registry);
  registerMethodCommandsForAsyncController(registry);
  registerMethodCommandsForTextFieldController(registry);
}
