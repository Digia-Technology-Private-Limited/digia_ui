import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:digia_ui/core/page/dui_page_bloc.dart';
import 'package:digia_ui/core/page/dui_page_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'button.props.dart';

class DUIButton extends StatefulWidget {
  final DUIButtonProps props;
  // TODO: GLobalKey is needed for different shapes, but that causes
  // interference with DUIButton.create function which is needed
  // to render from json.
  // final GlobalKey globalKey = GlobalKey();
  const DUIButton(this.props, {super.key}) : super();

  @override
  State<StatefulWidget> createState() => _DUIButtonState();
}

class _DUIButtonState extends State<DUIButton> {
  late DUIButtonProps props;
  late RenderBox renderbox;
  double width = 0;
  double height = 0;
  final bool _isLoading = false;
  final bool _actionInProgress = false;
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
    final bloc = context.read<DUIPageBloc>();
    final styleclass = props.disabled == true
        ? props.styleClass?.copyWith(bgColor: props.disabledBackgroundColor)
        : props.styleClass;

    final childToRender = DUIContainer(
        styleClass: styleclass,
        child: _isLoading
            ? const SizedBox(
                width: 32, height: 32, child: CircularProgressIndicator())
            : DUIText(props.text));

    return props.onClick == null
        ? childToRender
        : GestureDetector(
            onTap: () async {
              // TODO: WIP. This needs to be thought through
              bloc.add(
                  PostActionEvent(action: props.onClick!, context: context));
              // if (_actionInProgress) return;
              // TODO: Remove this Custom logic -> Move to JSON
              // ActionHandler().executeAction(context, props.onClick!);
              // setState(() {
              //   _isLoading = (props.setLoading == true) | true;
              //   _actionInProgress = true;
              // });

              // ActionHandler().executeAction(context, action)

              // final isValid = signUpFormGlobalKey.currentState!.validate();
              // if (isValid) {
              //   signUpFormGlobalKey.currentState!.save();
              // }

              // var resp = await RestHandler().executeAction(
              //     context,
              //     ActionProp(type: 'Action.restCall', data: {
              //       'method': 'POST',
              //       'url': 'https://napi.easyeat.ai/api/auth/login',
              //       'keyToReadFrom': null,
              //       'body': {
              //         'login_email': signInFormData['email'],
              //         'password': signInFormData['password'],
              //         'role': 'rest_hq_admin',
              //       }
              //     }));

              // if (resp['token'] == null) {
              //   final message = resp['message'] ?? resp['error'];
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //     content: Text('Error: $message'),
              //   ));
              //   setState(() {
              //     _isLoading = false;
              //     _actionInProgress = false;
              //   });
              //   return;
              // }
              // final restaurants = resp['mall_restaurants'] as List<dynamic>?;

              // if (restaurants != null) {
              //   List<String> ids = restaurants.map((o) {
              //     return o['id'] as String;
              //   }).toList();
              //   await PrefUtil.set('restaurant_ids', ids);
              // }

              // await PrefUtil.setString('authToken', 'Bearer ${resp['token']}');
              // if (context.mounted) {
              //   setState(() {
              //     _isLoading = false;
              //     _actionInProgress = false;
              //   });
              //   await ActionHandler().executeAction(
              //       context,
              //       ActionProp(type: 'Action.navigateToPage', data: {
              //         'pageName': 'easy-eat',
              //       }));
              // }
            },
            child: childToRender);
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
