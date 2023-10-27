import 'package:digia_ui/core/flutter_widgets.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

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
