import 'package:flutter/material.dart';
import '../Utils/basic_shared_utils/dui_decoder.dart';
import '../Utils/basic_shared_utils/lodash.dart';
import '../Utils/basic_shared_utils/num_decoder.dart';
import '../Utils/util_functions.dart';
import 'builders/dui_icon_builder.dart';
import 'builders/dui_text_builder.dart';
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
    builder: (ctx) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: DUIDecoder.toBorderRadius(style['borderRadius']),
          border: (style['borderStyle'] != null &&
                  style['borderStyle'] == 'solid')
              ? Border.all(
                  style: BorderStyle.solid,
                  color: eval<String>(style['borderColor'], context: context)
                          .letIfTrue(toColor) ??
                      Colors.transparent,
                  width: NumDecoder.toDoubleOrDefault(style['borderWidth'],
                      defaultValue: 1.0),
                )
              : null,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.04,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (style['text'] != null)
                      FittedBox(
                          child: DUITextBuilder.fromProps(props: style['text'])
                              .build(context)),
                    if (style['icon'] != null)
                      FittedBox(
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(ctx);
                            },
                            child:
                                DUIIconBuilder.fromProps(props: style['icon'])
                                    .build(context)),
                      )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.52,
              child: DUIPage(
                pageUid: pageUid,
                pageArgs: pageArgs,
              ),
            ),
          ],
        ),
      );
    },
  );
}
