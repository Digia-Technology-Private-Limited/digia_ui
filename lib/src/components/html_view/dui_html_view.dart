import 'package:digia_ui/src/components/html_view/dui_htmview_props.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DUIHtmlView extends StatelessWidget {
  final DUIHtmlViewProps props;
  const DUIHtmlView(this.props, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Html(
        data: props.content,
      ),
    );
  }
}
