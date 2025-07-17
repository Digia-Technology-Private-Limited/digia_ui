import 'package:flutter/material.dart';
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
    final shouldInterceptBackButton =
        payload.eval<bool>(props.get('shouldInterceptBackButton')) ?? true;

    if (url == null) {
      return const Center(child: Text('Error: No URL provided'));
    }

    return _VWWebView(
      url: url,
      shouldInterceptBackButton: shouldInterceptBackButton,
    );
  }
}

class _VWWebView extends StatefulWidget {
  final String url;
  final bool shouldInterceptBackButton;

  const _VWWebView({
    required this.url,
    required this.shouldInterceptBackButton,
  });

  @override
  _VWWebViewState createState() => _VWWebViewState();
}

class _VWWebViewState extends State<_VWWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<bool> _handleBack() async {
    final canGoBack = await controller.canGoBack();
    if (canGoBack) {
      await controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS || !widget.shouldInterceptBackButton) {
      return WebViewWidget(controller: controller);
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _handleBack() && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: WebViewWidget(controller: controller),
    );
  }
}
