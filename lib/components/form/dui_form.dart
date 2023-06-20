import 'package:digia_ui/Utils/dui_widget_list_registry.dart';
import 'package:digia_ui/components/form/dui_form_props.dart';
import 'package:flutter/material.dart';

// TODO: Create Capabilities
GlobalKey<FormState> signUpFormGlobalKey = GlobalKey();
Map<String, dynamic> signInFormData = {};

class DUIForm extends StatefulWidget {
  // final GlobalKey? globalKey;
  final DUIFormProps props;
  const DUIForm({super.key, required this.props});

  factory DUIForm.create(Map<String, dynamic> json) => DUIForm(
        props: DUIFormProps.fromJson(json),
      );

  @override
  State<DUIForm> createState() => _DUIFormState();
}

class _DUIFormState extends State<DUIForm> {
  // GlobalKey<FormState>? _formKey;
  late DUIFormProps props;
  @override
  void initState() {
    // _formKey = widget.globalKey as GlobalKey<FormState>?;
    props = widget.props;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    return Form(
        key: signUpFormGlobalKey,
        child: Column(
          children: props.children
              .map((child) => DUIFormRegistry[child.type]?.call(child.data))
              .nonNulls
              .toList(),
        ));
  }
}
