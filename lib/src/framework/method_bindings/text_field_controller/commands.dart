import 'package:flutter/widgets.dart';
import '../base.dart';

class TextFieldControllerSetValueCommand
    implements MethodCommand<TextEditingController> {
  @override
  void run(TextEditingController instance, Map<String, Object?> args) {
    dynamic value = args['value'];
    instance.value = value;
  }
}

class TextFieldControllerClearCommand
    implements MethodCommand<TextEditingController> {
  @override
  void run(TextEditingController instance, Map<String, Object?> args) {
    instance.clear();
  }
}
