import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../../components/dui_widget_creator_fn.dart';
import '../../framework/utils/functional_util.dart';
import '../action/action_prop.dart';
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
    return AppBar(
      title: DUITextBuilder.fromProps(
              props: as$<Map<String, dynamic>>(data.props['title']))
          .build(context),
      elevation: eval<double>(data.props['elevation'], context: context),
      shadowColor: (data.props['shadowColor'] as String?).letIfTrue(toColor),
      backgroundColor:
          (data.props['backgrounColor'] as String?).letIfTrue(toColor),
      iconTheme: IconThemeData(
          color: (data.props['iconColor'] as String?).letIfTrue(toColor)),
      automaticallyImplyLeading: true,
      leading: () {
        if (leadingIcon != null) return leadingIcon;

        return DUIIconBuilder.fromProps(props: data.props['leadingIcon']).let(
            (iconBuilder) => DUIGestureDetector(
                context: context,
                actionFlow: ActionFlow.fromJson(data.props['onTapLeadingIcon']),
                child: iconBuilder.build(context)));
      }(),
      actions: trailingIcon.let((p0) => [p0]),
    );
  }
}
