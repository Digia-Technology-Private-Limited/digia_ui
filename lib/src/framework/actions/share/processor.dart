import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../base/processor.dart';
import 'action.dart';

class ShareProcessor implements ActionProcessor<ShareAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ShareAction action,
    ExprContext? exprContext,
  ) async {
    final message = action.message?.evaluate(exprContext);
    final subject = action.subject?.evaluate(exprContext);

    if (message != null && message.isNotEmpty) {
      if (kIsWeb) {
        _showWebDialog(context, message);
      } else {
        await Share.share(message, subject: subject);
      }
      return null;
    } else {
      return null;
    }
  }

  void _showWebDialog(BuildContext context, String message) {
    showDialog(
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
