import 'package:flutter/material.dart';
import '../Utils/basic_shared_utils/lodash.dart';
import '../Utils/basic_shared_utils/num_decoder.dart';
import '../Utils/util_functions.dart';
import '../components/dui_icons/icon_helpers/icon_data_serialization.dart';
import 'evaluator.dart';
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

Future<Widget?> openDUIPageInBottomSheet({
  required String pageUid,
  required BuildContext context,
  required Map<String, dynamic> style,
  Map<String, dynamic>? pageArgs,
}) {
  return showModalBottomSheet(
    barrierColor:
        eval<String>(style['bgColor'], context: context).letIfTrue(toColor) ??
            Colors.black.withOpacity(0.4),
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (ctx) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Stack(
          children: [
            DUIPage(
              pageUid: pageUid,
              pageArgs: pageArgs,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    Navigator.maybePop(context);
                  },
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Icon(
                      getIconData(icondataMap: style['icon']['iconData']),
                      color: Colors.white.withOpacity(0.5),
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
