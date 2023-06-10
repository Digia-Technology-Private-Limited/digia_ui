import 'package:digia_ui/components/form/dui_form_props.dart';
import 'package:digia_ui/components/form/dui_text_field.dart';
import 'package:flutter/material.dart';

typedef WidgetCreator = Widget Function(Map<String, dynamic> json);

// ignore: constant_identifier_names
const Map<String, WidgetCreator> DUIFormRegistry = {
  'digia/textformfield': DUITextField.create,
};

class DUIForm extends StatefulWidget {
  final DUIFormProps props;
  const DUIForm({super.key, required this.props});

  @override
  State<DUIForm> createState() => _DUIFormState();
}

class _DUIFormState extends State<DUIForm> {
  late DUIFormProps props;
  @override
  void initState() {
    props = widget.props;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    return Form(
        child: Column(
      children: props.children
          .map((child) => DUIFormRegistry[child.type]?.call(child.data))
          .nonNulls
          .toList(),
    ));
  }
}

const Map<String, dynamic> emailTextField = {
  'textStyle': 'ft:para1;tc:text',
  'label': {'text': 'Email', 'styleClass': 'ft:para1;tc:textSubtle'},
  'border': 'bdc:#FFBF00; bdr:8; bdw:20',
  'focusedBorder': 'bdc:#00FF00; bdr:20; bdw:1',
  'hintText': 'Enter your Email Id',
  'hintTextStyle': 'ft:caption; tc:accent4'
};

const Map<String, dynamic> passwordTextField = {
  'textStyle': 'ft:para1;tc:text',
  'label': {'text': 'Password', 'styleClass': 'ft:para1;tc:textSubtle'},
  'border': 'bdc:#FFBF00; bdr:8; bdw:20',
  'focusedBorder': 'bdc:#00FF00; bdr:20; bdw:1',
  'hintText': 'Enter your Password',
  'hintTextStyle': 'ft:caption; tc:accent4'
};

const Map<String, dynamic> sampleForm = {
  'children': [
    {'type': 'digia/textformfield', 'data': emailTextField},
    {'type': 'digia/textformfield', 'data': passwordTextField}
  ]
};
