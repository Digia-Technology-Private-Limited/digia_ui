import 'package:flutter/widgets.dart';
import '../../../utils/functional_util.dart';
import '../../adapted_types/text_editing_controller.dart';
import '../base.dart';

class TextFieldControllerSetValueCommand
    implements MethodCommand<AdaptedTextEditingController> {
  @override
  void run(TextEditingController instance, Map<String, Object?> args) {
    instance.text = as$<String>(args['text']) ?? '';
  }
}

class TextFieldControllerClearCommand
    implements MethodCommand<AdaptedTextEditingController> {
  @override
  void run(TextEditingController instance, Map<String, Object?> args) {
    instance.clear();
  }
}
