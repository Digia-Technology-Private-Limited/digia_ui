import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';
import 'dui_text_builder.dart';

class DUIAppBarBuilder extends DUIWidgetBuilder {
  DUIAppBarBuilder({required super.data, this.leadingIcon, this.trailingIcon});

  final Icon? leadingIcon;
  final Icon? trailingIcon;

  static DUIAppBarBuilder? create(DUIWidgetJsonData data,
      {Icon? leadingIcon, Icon? trailingIcon}) {
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
      automaticallyImplyLeading: false,
      leading: leadingIcon != null
          ? IconButton(
              icon: leadingIcon!,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            )
          : parentRoute?.impliesAppBarDismissal ?? false
              ? useCloseButton
                  ? const CloseButton()
                  : const BackButton()
              : null,
      actions: [
        Builder(builder: (context) {
          if (trailingIcon != null) {
            return IconButton(
              icon: trailingIcon!,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          }
          return const SizedBox();
        }),
      ],
    );
  }
}
