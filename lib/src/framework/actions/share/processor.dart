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
    required String eventId,
    required String parentId,
  }) async {
    final message = action.message?.evaluate(scopeContext);
    final subject = action.subject?.evaluate(scopeContext);

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'message': message,
        'subject': subject,
      },
    );

    executionContext?.notifyStart(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
    );

    executionContext?.notifyProgress(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
      details: {
        'message': message,
        'subject': subject,
        'messageLength': message?.length,
        'isWeb': kIsWeb,
      },
    );

    if (message != null && message.isNotEmpty) {
      if (kIsWeb) {
        _showWebDialog(context, message);
      } else {
        await SharePlus.instance.share(ShareParams(
          subject: subject,
          text: message,
        ));
      }

      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: null,
        stackTrace: null,
      );
      return null;
    } else {
      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: null,
        stackTrace: null,
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
