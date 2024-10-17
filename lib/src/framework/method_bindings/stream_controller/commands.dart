import 'dart:async';
import '../../utils/object_util.dart';
import '../base.dart';

class StreamControllerAddCommand implements MethodCommand<StreamController> {
  @override
  void run(StreamController instance, Map<String, Object?> args) {
    Stream? stream = args['stream']?.to<Stream>();
    instance.add(stream);
  }
}

class StreamControllerAddErrorCommand
    implements MethodCommand<StreamController> {
  @override
  void run(StreamController instance, Map<String, Object?> args) {
    Object? error = args['error'];
    if (error != null) {
      instance.addError(error);
    }
  }
}

class StreamControllerCloseCommand implements MethodCommand<StreamController> {
  @override
  void run(StreamController instance, Map<String, Object?> args) {
    instance.close();
  }
}
