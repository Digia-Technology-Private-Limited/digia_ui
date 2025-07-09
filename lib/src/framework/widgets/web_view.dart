import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWWebView extends VirtualLeafStatelessWidget<Props> {
  VWWebView({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final url = payload.eval<String>(props.get('url'));

    if (url == null) {
      return const Center(child: Text('Error: No URL provided'));
    }

    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return WebViewWidget(
      controller: controller,
    );
  }
}
