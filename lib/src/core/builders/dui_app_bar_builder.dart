import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';
import 'dui_text_builder.dart';

class DUIAppBarBuilder extends DUIWidgetBuilder {
  DUIAppBarBuilder({required super.data});

  static DUIAppBarBuilder? create(DUIWidgetJsonData data) {
    return DUIAppBarBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title:
            DUITextBuilder.fromProps(props: data.props['title']).build(context),
        elevation: eval<double>(data.props['elevation'], context: context),
        shadowColor: (data.props['shadowColor'] as String?).letIfTrue(toColor),
        backgroundColor:
            (data.props['backgrounColor'] as String?).letIfTrue(toColor),
        iconTheme: IconThemeData(
            color: (data.props['iconColor'] as String?).letIfTrue(toColor)));
  }
}
