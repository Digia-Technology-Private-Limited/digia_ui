import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/flutter_type_converters.dart';
import '../base/processor.dart';
import 'action.dart';

class OpenUrlProcessor implements ActionProcessor<OpenUrlAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    OpenUrlAction action,
    ExprContext? exprContext,
  ) async {
    final urlString = action.url?.evaluate(exprContext);
    final launchMode = To.uriLaunchMode(action.launchMode);

    if (urlString == null) {
      throw ArgumentError('URL is null');
    }

    final url = Uri.parse(urlString);
    final canOpenUrl = await canLaunchUrl(url);

    if (canOpenUrl) {
      return launchUrl(
        url,
        mode: launchMode,
      );
    } else {
      throw 'Not allowed to open url: $url';
    }
  }
}
