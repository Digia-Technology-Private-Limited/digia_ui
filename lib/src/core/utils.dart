import 'package:flutter/material.dart';
import '../Utils/basic_shared_utils/dui_decoder.dart';
import '../Utils/basic_shared_utils/lodash.dart';
import '../Utils/util_functions.dart';
import '../components/dui_icons/icon_helpers/icon_data_serialization.dart';
import '../types.dart';
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
            settings: RouteSettings(name: '/duiRoute-$pageUid'),
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
      ));
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
                onMessageReceived: onMessageReceived,
                iconDataProvider: iconDataProvider,
                imageProviderFn: imageProviderFn,
                textStyleBuilder: textStyleBuilder,
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
                        color:
                            eval<String>(style['iconBgColor'], context: context)
                                    .letIfTrue(toColor) ??
                                Colors.black.withOpacity(0.3),
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
