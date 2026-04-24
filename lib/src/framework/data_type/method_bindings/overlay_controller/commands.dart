import '../../adapted_types/overlay_controller.dart';
import '../base.dart';

class OverlayControllerShowCommand
    implements MethodCommand<AdaptedOverlayController> {
  @override
  void run(AdaptedOverlayController instance, Map<String, Object?> args) {
    instance.show();
  }
}

class OverlayControllerHideCommand
    implements MethodCommand<AdaptedOverlayController> {
  @override
  void run(AdaptedOverlayController instance, Map<String, Object?> args) {
    instance.hide();
  }
}

class OverlayControllerToggleCommand
    implements MethodCommand<AdaptedOverlayController> {
  @override
  void run(AdaptedOverlayController instance, Map<String, Object?> args) {
    instance.toggle();
  }
}
