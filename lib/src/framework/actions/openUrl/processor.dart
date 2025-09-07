import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../expr/scope_context.dart';
import '../../utils/flutter_type_converters.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class OpenUrlProcessor extends ActionProcessor<OpenUrlAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    OpenUrlAction action,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) async {
    final urlString = action.url?.evaluate(scopeContext);
    final launchMode = To.uriLaunchMode(action.launchMode);

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'url': urlString,
        'launchMode': action.launchMode,
      },
    );

    executionContext?.notifyStart(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
    );

    if (urlString == null) {
      final error = ArgumentError('URL is null');
      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: error,
        stackTrace: StackTrace.current,
      );
      throw error;
    }

    executionContext?.notifyProgress(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
      details: {
        'url': urlString,
        'launchMode': action.launchMode,
      },
    );

    final url = Uri.parse(urlString);
    final canOpenUrl = await canLaunchUrl(url);

    if (canOpenUrl) {
      final result = await launchUrl(
        url,
        mode: launchMode,
      );

      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: null,
        stackTrace: null,
      );

      return result;
    } else {
      final error = 'Not allowed to open url: $url';
      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: error,
        stackTrace: StackTrace.current,
      );
      throw error;
    }
  }
}
