import 'package:digia_ui/src/components/html_view/dui_html_view.dart';
import 'package:digia_ui/src/components/html_view/dui_htmview_props.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIHtmlViewBuilder extends DUIWidgetBuilder {
  DUIHtmlViewBuilder({required super.data});

  static DUIHtmlViewBuilder? create(DUIWidgetJsonData data) {
    return DUIHtmlViewBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIHtmlView(DUIHtmlViewProps.fromJson(data.props));
  }
}
