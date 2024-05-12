import 'package:digia_ui/src/core/page/dui_page.dart';
import 'package:flutter/material.dart';

Future<Object?> openDUIPage(
    {required String pageUid,
    required BuildContext context,
    Map<String, dynamic>? pageArgs}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (ctx) {
        return DUIPage(
          pageUid: pageUid,
          pageArgs: pageArgs,
        );
      },
    ),
  );
}

Future<Widget?> showAlertDialog(
    {required BuildContext context,
    required String type,
    required String title,
    required String content,
    String confirmText = 'Okay',
    String cancelText = 'Cancel'}) {
  return showAdaptiveDialog<Widget?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(confirmText),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(cancelText)),
        ],
      );
    },
  );
}
