import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/form/dui_text_field_props.dart';
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

  @override
  void initState() {
    super.initState();
    props = widget.props;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: (value) {
          print(value);
          return null;
        },
        controller: userInput,
        style: toTextStyle(props.textStyle),
        decoration: InputDecoration(
            label: DUIText(props.label),
            border: toOutlineInputBorder(props.border),
            focusedBorder: toOutlineInputBorder(props.focusedBorder),
            hintText: props.hintText,
            hintStyle: toTextStyle(props.hintTextStyle)));
  }
}

//               child: TextFormField(
//                 controller: userInput,
//                 style: TextStyle(
//                   fontSize: 24,
//                   color: Colors.blue,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     // userInput.text = value.toString();
//                   });
//                 },
//                 decoration: InputDecoration(
//                     // counterText: "Counter Text",
//                     semanticCounterText: "Semantic Counter Text",
//                     icon: Icon(Icons.abc_rounded),
//                     // label: Wrap(children: [Icon(Icons.ac_unit), Text("Lol")]),
//                     focusColor: Colors.white,
//                     //add prefix icon
//                     prefixIcon: Icon(
//                       Icons.person_outline_rounded,
//                       color: Colors.grey,
//                     ),
//                     suffix: Text("Suffix Text Widget"),
//                     errorText: switchValue ? null : "Error Text",
//                     errorStyle: TextStyle(
//                       color: Colors.red,
//                       fontSize: 32,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     isCollapsed: false,
//                     floatingLabelBehavior: FloatingLabelBehavior.auto,
//                     fillColor: Colors.grey,
//                     hintText: "Hint Text",
//                     helperText: "Helper Text",
//                     //make hint text
//                     hintStyle: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 16,
//                       fontFamily: "verdana_regular",
//                       fontWeight: FontWeight.w400,
//                     ),

//                     // create lable
//                     labelText: 'Label Text',
//                     // lable style
//                     labelStyle: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 16,
//                       fontFamily: "Poppins",
//                       fontWeight: FontWeight.w400,
//                     ),
//                     floatingLabelStyle:
//                         TextStyle(backgroundColor: Colors.amber)),
//               ),
//             ),
//             Text(userInput.text),
