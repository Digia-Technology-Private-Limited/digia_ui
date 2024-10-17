import 'package:flutter/widgets.dart';
import '../../../utils/functional_util.dart';
import '../base.dart';

class TextFieldControllerSetValueCommand
    implements MethodCommand<TextEditingController> {
  @override
  void run(TextEditingController instance, Map<String, Object?> args) {
    instance.text = as$<String>(args['text']) ?? '';
  }
}

class TextFieldControllerClearCommand
    implements MethodCommand<TextEditingController> {
  @override
  void run(TextEditingController instance, Map<String, Object?> args) {
    instance.clear();
  }
}
