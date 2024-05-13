import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../digia_ui.dart';
import '../json_widget_builder.dart';

class DUIWebViewBuilder extends DUIWidgetBuilder {
  DUIWebViewBuilder({required super.data});

  static DUIWebViewBuilder? create(DUIWidgetJsonData data) {
    return DUIWebViewBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final url = data.props['url'] as String;
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return WebViewWidget(
      controller: controller,
    );
  }
}
