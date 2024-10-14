import '../../internal_widgets/timer/controller.dart';
import '../base.dart';

class TimerControllerStartCommand implements MethodCommand<TimerController> {
  @override
  void run(TimerController instance, List<Object?> args) {
    instance.start();
  }
}

class TimerControllerResumeCommand implements MethodCommand<TimerController> {
  @override
  void run(TimerController instance, List<Object?> args) {
    instance.resume();
  }
}

class TimerControllerPauseCommand implements MethodCommand<TimerController> {
  @override
  void run(TimerController instance, List<Object?> args) {
    instance.pause();
  }
}

class TimerControllerResetCommand implements MethodCommand<TimerController> {
  @override
  void run(TimerController instance, List<Object?> args) {
    instance.reset();
  }
}
