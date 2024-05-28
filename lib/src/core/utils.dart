import 'package:flutter/material.dart';
import '../Utils/basic_shared_utils/dui_decoder.dart';
import '../Utils/basic_shared_utils/lodash.dart';
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
    scrollControlDisabledMaxHeightRatio: 0.7,
    barrierColor:
        eval<String>(style['bgColor'], context: context).letIfTrue(toColor) ??
            Colors.black.withOpacity(0.4),
    context: context,
    builder: (ctx) {
      return Container(
        color: eval<String>(style['bgColor'], context: context)
                .letIfTrue(toColor) ??
            Colors.black.withOpacity(0.4),
        child: ClipRRect(
          borderRadius: DUIDecoder.toBorderRadius(style['borderRadius']),
          child: Stack(
            children: [
              DUIPage(
                pageUid: pageUid,
                pageArgs: pageArgs,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
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
        ),
      );
    },
  );
}
