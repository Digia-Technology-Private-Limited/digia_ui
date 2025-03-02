import 'api_cancel_token/register_fn.dart';
import 'async_controller/register_fn.dart';
import 'file/register_fn.dart';
import 'method_binding_registry.dart';
import 'scroll_controller/register_fn.dart';
import 'stream_controller/register_fn.dart';
import 'text_field_controller/register_fn.dart';
import 'timer_controller/register_fn.dart';

void registerBindings(MethodBindingRegistry registry) {
  registerMethodCommandsForScrollController(registry);
  registerMethodCommandsForStreamController(registry);
  registerMethodCommandsForTimerController(registry);
  registerMethodCommandsForAsyncController(registry);
  registerMethodCommandsForTextFieldController(registry);
  registerMethodCommandsForApiCancelToken(registry);
  registerMethodCommandsForFile(registry);
}
