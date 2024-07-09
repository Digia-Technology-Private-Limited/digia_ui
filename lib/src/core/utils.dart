import 'dart:ui';

import 'package:flutter/material.dart';
import '../Utils/basic_shared_utils/color_decoder.dart';
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

// TODO: Needs to be redesigned from scratch;
Future<T?> openDUIPageInBottomSheet<T>({
  required String pageUid,
  required BuildContext context,
  required Map<String, dynamic> style,
  Map<String, dynamic>? pageArgs,
  DUIMessageHandler? onMessageReceived,
  DUIIconDataProvider? iconDataProvider,
  DUIImageProviderFn? imageProviderFn,
  DUITextStyleBuilder? textStyleBuilder,
}) {
  final bgColor =
      eval<String>(style['bgColor'], context: context).letIfTrue(toColor);
  final barrierColor = eval<String>(style['barrierColor'], context: context)
          .letIfTrue(toColor) ??
      ColorDecoder.fromHexString('#2e2e2e').withOpacity(0.6);
  final isDismissible =
      eval<bool>(style['isDismissible'], context: context) ?? true;
  final useSafeArea =
      eval<bool>(style['useSafeArea'], context: context) ?? false;
  final maxHeightRatio =
      eval<double>(style['maxHeightRatio'], context: context) ?? 1;
  final showDragHandle =
      eval<bool>(style['showDragHandle'], context: context) ?? false;
  final handleBarHeight =
      eval<double>(style['handleBarHeight'], context: context) ?? 4;
  final handleBarWidth =
      eval<double>(style['handleBarWidth'], context: context) ?? 32;
  final dragHandleColor =
      eval<String>(style['dragHandleColor'], context: context)
          .letIfTrue(toColor);
  final enableDrag = eval<bool>(style['enableDrag'], context: context) ?? true;

  return showModalBottomSheet<T>(
    isDismissible: isDismissible,
    useSafeArea: useSafeArea,
    backgroundColor: bgColor,
    enableDrag: enableDrag,
    scrollControlDisabledMaxHeightRatio: maxHeightRatio,
    barrierColor: barrierColor,
    context: context,
    builder: (ctx) {
      final child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                border: toBorder(DUIBorder.fromJson(style), context),
                borderRadius: DUIDecoder.toBorderRadius(style['borderRadius']),
              ),
              clipBehavior: Clip.hardEdge,
              // elevation: 2,
              child: SafeArea(
                child: Stack(children: [
                  DUIPage(
                    pageUid: pageUid,
                    pageArgs: pageArgs,
                    onMessageReceived: onMessageReceived,
                    iconDataProvider: iconDataProvider,
                    imageProviderFn: imageProviderFn,
                    textStyleBuilder: textStyleBuilder,
                  ),
                  if (style.valueFor(keyPath: 'icon.iconData') != null)
                    Positioned(
                      top: 24,
                      right: 20,
                      child: InkWell(
                        onTap: () {
                          Navigator.maybePop(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.withOpacity(0.1)),
                          child: DUIIconBuilder.fromProps(props: style['icon'])
                              ?.build(context),
                        ),
                      ),
                    ),
                ]),
              ),
            ),
          ),
        ],
      );
      return showDragHandle
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: BottomSheet(
                // enableDrag should not be 'true' as it interfares with showModelBottomSheet's enableDrag
                  enableDrag: false,
                  backgroundColor: bgColor,
                  showDragHandle: showDragHandle,
                  dragHandleColor: dragHandleColor,
                  dragHandleSize: Size(handleBarWidth, handleBarHeight),
                  onClosing: () {},
                  builder: (context) => child))
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), child: child);
    },
  );
}

// Container(
//         clipBehavior: Clip.hardEdge,
//         decoration: BoxDecoration(
//           color: bgColor,
//           border: toBorder(DUIBorder.fromJson(style)),
//           borderRadius: DUIDecoder.toBorderRadius(style['borderRadius']),
//         ),
//         child:

//       );

Future<T?> openDialog<T>({
  required String pageUid,
  required BuildContext context,
  Map<String, dynamic>? pageArgs,
  DUIIconDataProvider? iconDataProvider,
  DUIImageProviderFn? imageProviderFn,
  DUITextStyleBuilder? textStyleBuilder,
  bool? barrierDismissible,
  Color? barrierColor,
}) {
  return showDialog(
      context: context,
      useSafeArea: true,
      useRootNavigator: false,
      barrierDismissible: barrierDismissible ?? true,
      barrierColor: barrierColor,
      builder: (context) {
        return Dialog(
          child: DUIPage(
            pageUid: pageUid,
            pageArgs: pageArgs,
            iconDataProvider: iconDataProvider,
            imageProviderFn: imageProviderFn,
            textStyleBuilder: textStyleBuilder,
          ),
        );
      });
}
