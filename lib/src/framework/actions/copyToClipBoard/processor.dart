import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../digia_ui.dart';
import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class CopyToClipBoardProcessor extends ActionProcessor<CopyToClipBoardAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    CopyToClipBoardAction action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final message = action.message?.evaluate(scopeContext);

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'message': message,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      observabilityContext: observabilityContext,
    );

    final toast = FToast().init(context);
    final DigiaUIHost? host = DigiaUIManager().host;

    if (message != null && message.isNotEmpty) {
      executionContext?.notifyProgress(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        details: {
          'message': message,
          'messageLength': message.length,
          'hostType': host.runtimeType.toString(),
        },
        observabilityContext: observabilityContext,
      );

      try {
        await Clipboard.setData(ClipboardData(text: message));
        if (host is DashboardHost) {
          _showToast(toast, 'Copied to Clipboard!');
        }

        executionContext?.notifyComplete(
          id: id,
          parentActionId: parentActionId,
          descriptor: desc,
          error: null,
          stackTrace: null,
          observabilityContext: observabilityContext,
        );
      } catch (e) {
        if (host is DashboardHost) {
          _showToast(toast, 'Failed to copy to clipboard.');
        }

        executionContext?.notifyComplete(
          id: id,
          parentActionId: parentActionId,
          descriptor: desc,
          error: e,
          stackTrace: StackTrace.current,
          observabilityContext: observabilityContext,
        );
      }
      return null;
    } else {
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
