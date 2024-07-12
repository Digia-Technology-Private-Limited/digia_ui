import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIHtmlViewBuilder extends DUIWidgetBuilder {
  DUIHtmlViewBuilder({required super.data});

  static DUIHtmlViewBuilder? create(DUIWidgetJsonData data) {
    return DUIHtmlViewBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      data: eval<String>(data.props['content'], context: context),
    );
  }
}
