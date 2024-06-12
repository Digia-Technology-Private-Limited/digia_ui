import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';
import 'dui_icon_builder.dart';
import 'dui_text_builder.dart';

class DUIAppBarBuilder extends DUIWidgetBuilder {
  DUIAppBarBuilder({required super.data, this.leadingIcon, this.trailingIcon});

  final Widget? leadingIcon;
  final Widget? trailingIcon;

  static DUIAppBarBuilder? create(DUIWidgetJsonData data,
      {Widget? leadingIcon, Widget? trailingIcon}) {
    return DUIAppBarBuilder(
        data: data, leadingIcon: leadingIcon, trailingIcon: trailingIcon);
  }

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    return AppBar(
      title:
          DUITextBuilder.fromProps(props: data.props['title']).build(context),
      elevation: eval<double>(data.props['elevation'], context: context),
      shadowColor: (data.props['shadowColor'] as String?).letIfTrue(toColor),
      backgroundColor:
          (data.props['backgrounColor'] as String?).letIfTrue(toColor),
      iconTheme: IconThemeData(
          color: (data.props['iconColor'] as String?).letIfTrue(toColor)),
      automaticallyImplyLeading: true,
      leading: leadingIcon != null
          ? Builder(
              builder: (context) => IconButton(
                  icon: leadingIcon is SizedBox
                      ? const DrawerButtonIcon()
                      : leadingIcon!,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  }))
          : (parentRoute?.impliesAppBarDismissal ?? false
              ? (useCloseButton
                  ? const CloseButton()
                  : (DUIIconBuilder.fromProps(props: data.props['backIcon'])
                          .build(context) is SizedBox
                      ? const BackButton()
                      : IconButton(
                          icon: DUIIconBuilder.fromProps(
                                  props: data.props['backIcon'])
                              .build(context),
                          onPressed: () => Navigator.maybePop(context),
                        )))
              : const SizedBox()),
      actions: [
        trailingIcon != null
            ? Builder(builder: (context) {
                return IconButton(
                    icon: trailingIcon is SizedBox &&
                            (trailingIcon as SizedBox).child == null
                        ? const EndDrawerButtonIcon()
                        : trailingIcon!,
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    });
              })
            : const SizedBox()
      ],
    );
  }
}
