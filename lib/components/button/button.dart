import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/form/dui_form.dart';
import 'package:digia_ui/core/action/action_handler.dart';
import 'package:digia_ui/core/action/action_prop.dart';
import 'package:digia_ui/core/action/rest_handler.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:digia_ui/core/pref/pref_util.dart';
import 'package:flutter/material.dart';

import 'button.props.dart';

class DUIButton extends StatefulWidget {
  final DUIButtonProps props;
  // TODO: GLobalKey is needed for different shapes, but that causes
  // interference with DUIButton.create function which is needed
  // to render from json.
  // final GlobalKey globalKey = GlobalKey();
  const DUIButton(this.props, {super.key}) : super();

  factory DUIButton.create(Map<String, dynamic> json) =>
      DUIButton(DUIButtonProps.fromJson(json));

  @override
  State<StatefulWidget> createState() => _DUIButtonState();
}

class _DUIButtonState extends State<DUIButton> {
  late DUIButtonProps props;
  late RenderBox renderbox;
  double width = 0;
  double height = 0;
  _DUIButtonState();

  @override
  void initState() {
    super.initState();
    props = widget.props;
    // TODO: Commented out for now. Check TODO near GlobalKey
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   renderbox =
    //       widget.globalKey.currentContext!.findRenderObject() as RenderBox;
    //   setState(() {
    //     width = renderbox.size.width;
    //     height = renderbox.size.height;
    //   });
    // });
  }

  // TODO: We may need to use Plain text here and not rich text.
  // Problem is we need we may need to change textColor in case of disabled state.
  // We would need to fetch a new textStyleClass for disabled state.
  // Not supporting it for now.
  @override
  Widget build(BuildContext context) {
    final styleclass = props.disabled == true
        ? props.styleClass?.copyWith(bgColor: props.disabledBackgroundColor)
        : props.styleClass;

    final widget =
        DUIContainer(styleClass: styleclass, child: DUIText(props.text));

    return props.onClick == null
        ? widget
        : InkWell(
            onTap: () async {
              // TODO: Remove this Custom logic -> Move to JSON
              // ActionHandler().executeAction(context, props.onClick!);
              final isValid = signUpFormGlobalKey.currentState!.validate();
              if (isValid) {
                signUpFormGlobalKey.currentState!.save();
              }

              var resp = await RestHandler().executeAction(
                  context,
                  ActionProp(type: 'rest_call', data: {
                    'method': 'POST',
                    'url': 'https://napi.easyeat.ai/api/auth/login',
                    'keyToReadFrom': null,
                    'body': {
                      'login_email': signInFormData['email'],
                      'password': signInFormData['password'],
                      'role': 'rest_hq_admin',
                    }
                  }));

              await PrefUtil.setString('authToken', resp['token']);
              if (context.mounted) {
                await ActionHandler().executeAction(
                    context,
                    ActionProp(type: 'navigate_to_page', data: {
                      'pageName': 'easy-eat',
                    }));
              }
            },
            child: widget);
    // child: Container(
    //   width: props.width,
    //   height: props.height,
    //   alignment: toAlignmentGeometry(props.alignment),
    //   padding: toEdgeInsetsGeometry(props.padding),
    //   margin: toEdgeInsetsGeometry(props.margin),
    //   decoration: BoxDecoration(
    //     color: props.disabled == true
    //         ? toColor(props.disabledBackgroundColor ??
    //             DUIConfigConstants.fallbackBgColorHexCode)
    //         : toColor(props.backgroundColor ??
    //             DUIConfigConstants.fallbackBgColorHexCode),
    //     // borderRadius: BorderRadius.circular(props.shape == 'pill'
    //     //     ? width / 2
    //     //     : props.shape == 'rect'
    //     //         ? width / 100
    //     //         : 0),
    //   ),
    //   child: DUIText(props.text),
    // ),
  }
}
