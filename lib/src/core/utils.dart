import 'package:flutter/material.dart';

import 'page/dui_page.dart';

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

Future<Object?> openDUIPageInBottomSheet({
  required String pageUid,
  required BuildContext context,
  Map<String, dynamic>? pageArgs,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return DUIPage(
        pageUid: pageUid,
        pageArgs: pageArgs,
      );
    },
  );
}
