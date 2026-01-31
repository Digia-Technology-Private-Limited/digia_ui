import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class ShareProcessor extends ActionProcessor<ShareAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ShareAction action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final message = action.message?.evaluate(scopeContext);
    final subject = action.subject?.evaluate(scopeContext);

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'message': message,
        'subject': subject,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      observabilityContext: observabilityContext,
    );

    executionContext?.notifyProgress(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      details: {
        'message': message,
        'subject': subject,
        'messageLength': message?.length,
        'isWeb': kIsWeb,
      },
      observabilityContext: observabilityContext,
    );

    Object? error;
    StackTrace? stackTrace;
    if (message is String && message.isNotEmpty) {
      try {
        if (kIsWeb) {
          _showWebDialog(context, message);
        } else {
          await SharePlus.instance.share(ShareParams(
            subject: subject,
            text: message,
          ));
        }
      } catch (e, s) {
        error = e;
        stackTrace = s;
      } finally {
        executionContext?.notifyComplete(
          id: id,
          parentActionId: parentActionId,
          descriptor: desc,
          error: error,
          stackTrace: stackTrace,
          observabilityContext: observabilityContext,
        );
      }
      return null;
    } else {
      // Nothing to share; still mark complete.
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: null,
        stackTrace: null,
        observabilityContext: observabilityContext,
      );
      return null;
    }
  }

  void _showWebDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (cntxt) {
        return AlertDialog(
          title: const Text('Notice'),
          content: Text(
              'This feature works only on mobile devices.\n\nMessage: "$message"'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(cntxt).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
