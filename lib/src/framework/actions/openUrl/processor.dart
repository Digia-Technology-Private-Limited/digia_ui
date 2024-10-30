import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../expr/scope_context.dart';
import '../../utils/flutter_type_converters.dart';
import '../base/processor.dart';
import 'action.dart';

class OpenUrlProcessor extends ActionProcessor<OpenUrlAction> {
  OpenUrlProcessor({super.logger});

  @override
  Future<Object?>? execute(
    BuildContext context,
    OpenUrlAction action,
    ScopeContext? scopeContext,
  ) async {
    final urlString = action.url?.evaluate(scopeContext);
    final launchMode = To.uriLaunchMode(action.launchMode);

    if (urlString == null) {
      throw ArgumentError('URL is null');
    }

    logger?.logAction(
      entitySlug: scopeContext!.name,
      actionType: action.actionType.value,
      actionData: {
        'url': urlString,
        'launchMode': action.launchMode,
      },
    );

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
