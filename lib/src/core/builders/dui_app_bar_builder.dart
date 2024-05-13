import 'package:flutter/material.dart';

import '../flutter_widgets.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIAppBarBuilder extends DUIWidgetBuilder {
  DUIAppBarBuilder({required super.data});

  static DUIAppBarBuilder? create(DUIWidgetJsonData data) {
    return DUIAppBarBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return FW.appBar(data.props);
  }
}
