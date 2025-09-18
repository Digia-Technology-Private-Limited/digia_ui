import 'package:digia_inspector_core/digia_inspector_core.dart';
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
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final urlString = action.url?.evaluate(scopeContext);
    final launchMode = To.uriLaunchMode(action.launchMode);

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'url': urlString,
        'launchMode': action.launchMode,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      observabilityContext: observabilityContext,
    );

    if (urlString == null) {
      final error = ArgumentError('URL is null');
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: error,
        stackTrace: StackTrace.current,
        observabilityContext: observabilityContext,
      );
      throw error;
    }

    executionContext?.notifyProgress(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      details: {
        'url': urlString,
        'launchMode': action.launchMode,
      },
      observabilityContext: observabilityContext,
    );

    final trimmed = urlString.trim();
    final url = Uri.tryParse(trimmed);
    if (url == null) {
      final error = FormatException('Invalid URL: $trimmed');
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: error,
        stackTrace: StackTrace.current,
        observabilityContext: observabilityContext,
      );
      throw error;
    }

    try {
      final canOpenUrl = await canLaunchUrl(url);
      if (!canOpenUrl) {
        final error = StateError('Cannot open URL: $url');
        executionContext?.notifyComplete(
          id: id,
          parentActionId: parentActionId,
          descriptor: desc,
          error: error,
          stackTrace: StackTrace.current,
          observabilityContext: observabilityContext,
        );
        throw error;
      }

      final launched = await launchUrl(url, mode: launchMode);
      if (!launched) {
        final error = StateError('launchUrl returned false for: $url');
        executionContext?.notifyComplete(
          id: id,
          parentActionId: parentActionId,
          descriptor: desc,
          error: error,
          stackTrace: StackTrace.current,
          observabilityContext: observabilityContext,
        );
        throw error;
      }
    } catch (e, st) {
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: e,
        stackTrace: st,
        observabilityContext: observabilityContext,
      );
      rethrow;
    }

    executionContext?.notifyComplete(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      error: null,
      stackTrace: null,
      observabilityContext: observabilityContext,
    );
    return true;
  }
}
