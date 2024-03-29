import 'package:digia_ui/src/Utils/extensions.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/DUIText/dui_text.dart';
import 'package:digia_ui/src/components/form/dui_form.dart';
import 'package:digia_ui/src/components/form/dui_text_field_props.dart';
import 'package:flutter/material.dart';

class DUITextField extends StatefulWidget {
  final DUITextFieldProps props;
  const DUITextField({super.key, required this.props});

  factory DUITextField.create(Map<String, dynamic> json) =>
      DUITextField(props: DUITextFieldProps.fromJson(json));

  @override
  State<DUITextField> createState() => _DUITextFieldState();
}

class _DUITextFieldState extends State<DUITextField> {
  late DUITextFieldProps props;
  TextEditingController userInput = TextEditingController();

  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    props = widget.props;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        // TODO: Need better abstraction for obscureText, validator
        // and show password for password.
        obscureText: _obscureText,
        validator: (value) {
          if (value == null) return null;

          if (props.inputType == 'email') {
            if (!value.isValidEmail()) {
              return 'Invalid Email';
            }
          }
          return null;
        },
        onSaved: (newValue) {
          signInFormData[props.dataKey] = newValue;
        },
        controller: userInput,
        // style: toTextStyle(props.textStyle),
        decoration: InputDecoration(
          suffixIcon: props.inputType == 'password'
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: _obscureText
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                )
              : null,
          label: DUIText(props.label),
          border: toOutlineInputBorder(props.border),
          focusedBorder: toOutlineInputBorder(props.focusedBorder),
          hintText: props.hintText,
          // hintStyle: toTextStyle(props.hintTextStyle)
        ));
  }
}
