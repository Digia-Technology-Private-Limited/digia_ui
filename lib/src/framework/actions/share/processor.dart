import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../expr/scope_context.dart';
import '../base/processor.dart';
import 'action.dart';

class ShareProcessor extends ActionProcessor<ShareAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ShareAction action,
    ScopeContext? scopeContext,
  ) async {
    final message = action.message?.evaluate(scopeContext);
    final subject = action.subject?.evaluate(scopeContext);

    logAction(
      action.actionType.value,
      {
        'message': message,
        'subject': subject,
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
      return null;
    } else {
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
