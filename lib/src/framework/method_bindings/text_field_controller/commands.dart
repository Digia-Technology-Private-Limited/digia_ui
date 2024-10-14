import 'package:flutter/widgets.dart';
import '../base.dart';

class TextFieldControllerSetValueCommand
    implements MethodCommand<TextEditingController> {
  @override
  void run(TextEditingController instance, List<Object?> args) {
    dynamic offset = args[0];
    instance.value = offset;
  }
}

class TextFieldControllerClearCommand
    implements MethodCommand<TextEditingController> {
  @override
  void run(TextEditingController instance, List<Object?> args) {
    instance.clear();
  }
}
