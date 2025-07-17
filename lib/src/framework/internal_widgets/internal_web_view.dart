import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InternalWebView extends StatefulWidget {
  final String url;
  final bool shouldInterceptBackButton;

  const InternalWebView({
    super.key,
    required this.url,
    required this.shouldInterceptBackButton,
  });

  @override
  State<InternalWebView> createState() => _InternalWebViewState();
}

class _InternalWebViewState extends State<InternalWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void didUpdateWidget(InternalWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      controller.loadRequest(Uri.parse(widget.url));
    }
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
          Navigator.pop(context);
        }
      },
      child: WebViewWidget(controller: controller),
    );
  }
}
