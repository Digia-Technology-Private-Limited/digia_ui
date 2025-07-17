import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_web_view.dart';
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
        payload.eval<bool>(props.get('shouldInterceptBackButton')) ?? false;

    if (url == null) {
      return const Center(child: Text('Error: No URL provided'));
    }

    return InternalWebView(
      url: url,
      shouldInterceptBackButton: shouldInterceptBackButton,
    );
  }
}
