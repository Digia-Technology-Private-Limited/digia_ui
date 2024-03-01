import 'package:digia_ui/src/components/form/dui_form_props.dart';
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
    // TODO: @tushar Need to rethink this from scratch
    return const SizedBox.shrink();
    //
    // return Form(
    //     key: signUpFormGlobalKey,
    //     child: Column(
    //       children: props.children
    //           .map((child) => DUIFormRegistry[child.type]?.call(child.data))
    //           .nonNulls
    //           .toList(),
    //     ));
  }
}
