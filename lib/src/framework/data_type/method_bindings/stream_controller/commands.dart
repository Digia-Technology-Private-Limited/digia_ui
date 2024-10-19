import 'dart:async';
import '../base.dart';

class StreamControllerAddCommand
    implements MethodCommand<StreamController<Object?>> {
  @override
  void run(StreamController<Object?> instance, Map<String, Object?> args) {
    Object? value = args['value'];
    instance.add(value);
  }
}

// class StreamControllerAddErrorCommand
//     implements MethodCommand<StreamController> {
//   @override
//   void run(StreamController instance, Map<String, Object?> args) {
//     Object? error = args['error'];
//     if (error != null) {
//       instance.addError(error);
//     }
//   }
// }

class StreamControllerCloseCommand implements MethodCommand<StreamController> {
  @override
  void run(StreamController instance, Map<String, Object?> args) {
    instance.close();
  }
}
