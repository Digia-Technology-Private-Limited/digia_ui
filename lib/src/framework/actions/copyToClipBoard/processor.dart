import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../base/processor.dart';
import 'action.dart';

class CopyToClipBoardProcessor
    implements ActionProcessor<CopyToClipBoardAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    CopyToClipBoardAction action,
    ExprContext? exprContext,
  ) async {
    final message = action.message?.evaluate(exprContext);

    final toast = FToast().init(context);

    if (message != null && message.isNotEmpty) {
      try {
        await Clipboard.setData(ClipboardData(text: message));
        _showToast(toast, 'Copied to Clipboard!');
      } catch (e) {
        _showToast(toast, 'Failed to copy to clipboard.');
      }
      return null;
    } else {
      return null;
    }
  }

  void _showToast(FToast toast, String message) {
    toast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.black,
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
