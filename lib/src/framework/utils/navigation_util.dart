import 'dart:ui';

import 'package:flutter/material.dart';

Future<T?> presentDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  bool useSafeArea = true,
  bool useRootNavigator = false,
  RouteSettings? routeSettings,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  return showDialog(
      context: navigatorKey?.currentContext ?? context,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      routeSettings: routeSettings,
      builder: (context) {
        return Dialog(child: builder(context));
      });
}

// TODO: Needs to be redesigned from scratch;
Future<T?> presentBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double scrollControlDisabledMaxHeightRatio = 1,
  Color? backgroundColor,
  Color? barrierColor,
  BoxBorder? border,
  bool useSafeArea = true,
  BorderRadius? borderRadius,
  WidgetBuilder? iconBuilder,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  return showModalBottomSheet<T>(
    context: navigatorKey?.currentContext ?? context,
    backgroundColor: backgroundColor,
    scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
    barrierColor: barrierColor,
    useSafeArea: useSafeArea,
    // isScrollControlled: true,
    builder: (innerContext) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: border,
                  borderRadius: borderRadius,
                ),
                clipBehavior: Clip.hardEdge,
                // elevation: 2,
                child: SafeArea(
                  child: Stack(children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.viewInsetsOf(context).bottom),
                      child: builder(innerContext),
                    ),
                    if (iconBuilder != null)
                      Positioned(
                        top: 24,
                        right: 20,
                        child: InkWell(
                          onTap: () {
                            Navigator.maybePop(innerContext);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white.withOpacity(0.1)),
                            child: iconBuilder(innerContext),
                          ),
                        ),
                      ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

abstract class NavigatorHelper {
  static Future<T?> push<T extends Object?>(BuildContext context,
      GlobalKey<NavigatorState>? navigatorKey, Route<T> newRoute,
      {RoutePredicate? removeRoutesUntilPredicate}) {
    if (removeRoutesUntilPredicate == null) {
      final push =
          navigatorKey?.currentState?.push ?? Navigator.of(context).push;
      return push(newRoute);
    }

    final pushAndRemoveUntil = navigatorKey?.currentState?.pushAndRemoveUntil ??
        Navigator.of(context).pushAndRemoveUntil;
    return pushAndRemoveUntil(newRoute, removeRoutesUntilPredicate);
  }
}
