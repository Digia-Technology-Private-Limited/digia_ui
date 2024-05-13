import 'package:flutter/material.dart';

import '../../components/html_view/dui_html_view.dart';
import '../../components/html_view/dui_htmview_props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

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
