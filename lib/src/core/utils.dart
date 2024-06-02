import 'package:flutter/material.dart';
import '../Utils/basic_shared_utils/dui_decoder.dart';
import '../Utils/basic_shared_utils/lodash.dart';
import '../Utils/extensions.dart';
import '../Utils/util_functions.dart';
import '../components/utils/DUIBorder/dui_border.dart';
import '../types.dart';
import 'builders/dui_icon_builder.dart';
import 'evaluator.dart';
import 'page/dui_page.dart';

class DUIPageRoute<T> extends MaterialPageRoute<T> {
  DUIPageRoute({
    required String pageUid,
    required BuildContext context,
    Map<String, dynamic>? pageArgs,
    DUIMessageHandler? onMessageReceived,
    DUIIconDataProvider? iconDataProvider,
    DUIImageProviderFn? imageProviderFn,
    DUITextStyleBuilder? textStyleBuilder,
  }) : super(
            settings: RouteSettings(name: '/duiPageRoute-$pageUid'),
            builder: (context) {
              return DUIPage(
                pageUid: pageUid,
                pageArgs: pageArgs,
                iconDataProvider: iconDataProvider,
                imageProviderFn: imageProviderFn,
                textStyleBuilder: textStyleBuilder,
                onMessageReceived: onMessageReceived,
              );
            });
}

Future<Object?> openDUIPage({
  required String pageUid,
  required BuildContext context,
  Map<String, dynamic>? pageArgs,
  DUIMessageHandler? onMessageReceived,
  DUIIconDataProvider? iconDataProvider,
  DUIImageProviderFn? imageProviderFn,
  DUITextStyleBuilder? textStyleBuilder,
}) {
  return Navigator.push(
      context,
      DUIPageRoute(
          pageUid: pageUid,
          context: context,
          onMessageReceived: onMessageReceived,
          iconDataProvider: iconDataProvider,
          imageProviderFn: imageProviderFn,
          textStyleBuilder: textStyleBuilder,
          pageArgs: pageArgs));
}

Future<Widget?> openDUIPageInBottomSheet({
  required String pageUid,
  required BuildContext context,
  required Map<String, dynamic> style,
  Map<String, dynamic>? pageArgs,
  DUIMessageHandler? onMessageReceived,
  DUIIconDataProvider? iconDataProvider,
  DUIImageProviderFn? imageProviderFn,
  DUITextStyleBuilder? textStyleBuilder,
}) {
  return showModalBottomSheet(
    scrollControlDisabledMaxHeightRatio:
        eval<double>(style['maxHeightRatio'], context: context) ?? 0.7,
    barrierColor:
        eval<String>(style['bgColor'], context: context).letIfTrue(toColor) ??
            Colors.black.withOpacity(0.4),
    context: context,
    builder: (ctx) {
      return Container(
        decoration: BoxDecoration(
          border: toBorder(DUIBorder.fromJson(style)),
          color: eval<String>(style['bgColor'], context: context)
              .letIfTrue(toColor),
          borderRadius: DUIDecoder.toBorderRadius(style['borderRadius']),
        ),
        child: Stack(
          children: [
            DUIPage(
              pageUid: pageUid,
              pageArgs: pageArgs,
              onMessageReceived: onMessageReceived,
              iconDataProvider: iconDataProvider,
              imageProviderFn: imageProviderFn,
              textStyleBuilder: textStyleBuilder,
            ),
            // TODO => Remove this crap from here.
            // Should be send from inside DUIPage itself.
            if (style.valueFor(keyPath: 'icon.iconData') != null)
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.maybePop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.1)),
                    child: DUIIconBuilder.fromProps(props: style['icon'])
                        .build(context),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}
