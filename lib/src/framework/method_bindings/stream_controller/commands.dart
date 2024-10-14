import 'dart:async';
import '../../utils/object_util.dart';
import '../base.dart';

class StreamControllerAddCommand implements MethodCommand<StreamController> {
  @override
  void run(StreamController instance, List<Object?> args) {
    Stream? offset = args[0]?.to<Stream>();
    instance.add(offset);
  }
}

class StreamControllerAddErrorCommand
    implements MethodCommand<StreamController> {
  @override
  void run(StreamController instance, List<Object?> args) {
    Object? error = args[0];
    if (error != null) {
      instance.addError(error);
    }
  }
}

class StreamControllerCloseCommand implements MethodCommand<StreamController> {
  @override
  void run(StreamController instance, List<Object?> args) {
    instance.close();
  }
}
