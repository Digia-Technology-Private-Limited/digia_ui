import 'package:digia_ui/src/core/page/dui_page.dart';
import 'package:flutter/material.dart';

Future<Object?> openDUIPage({
  required String pageUid,
  required BuildContext context,
  Function(String methodId, Map<String, dynamic>? data)? onExternalMethodCalled,
  Map<String, dynamic>? pageArguments,
}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (ctx) {
        return DUIPage(
          pageUid: pageUid,
          onExternalMethodCalled: onExternalMethodCalled,
          pageArguments: pageArguments,
        );
      },
    ),
  );
}
