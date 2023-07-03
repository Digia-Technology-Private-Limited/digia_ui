import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/core/appbar/appbar_props.dart';
import 'package:flutter/material.dart';

import '../components/DUIIcon/dui_icon.dart';
import '../components/DUIIcon/dui_icon_props.dart';

class FW {
  static SizedBox sizedBox(Map<String, dynamic> json) {
    final width = tryParseToDouble(json['width']);
    final height = tryParseToDouble(json['height']);
    return SizedBox(
      width: width,
      height: height,
    );
  }

  // This does not work well directly inside a Container.
  // Avoid using it with styleClass.
  static Widget spacer(Map<String, dynamic>? json) {
    final flex = json?['flex'] as int? ?? 1;
    return Spacer(flex: flex);
  }

  static AppBar appBar(Map<String, dynamic> json) {
    AppBarProps props = AppBarProps.fromJson(json);

    late List<Widget> actions;
    if (props.actions != null) {
      actions = props.actions!.map((e) {
        return IconButton(
          tooltip: e['title'],
          onPressed: () {},
          icon: DUIIcon(props: DUIIconProps.fromJson(e['icon'])!),
        );
      }).toList();
      // for (final action in props.actions!) {
      //   actions.add(
      //     IconButton(
      //       tooltip: action['title'],
      //       onPressed: () {},
      //       icon: DUIIcon(props: DUIIconProps.fromJson(action['icon'])!),
      //     ),
      //   );
      // }
    }
    return AppBar(
      leading: props.back == true
          ? const BackButton(
              // TODO: add the Navigator.pop functionality
              )
          : null,
      actions: [
        ...actions,
        json['popUpMenu'] != null
            ? PopupMenuButton(
                itemBuilder: (context) {
                  return (json['popUpMenu']['items'] as List<dynamic>)
                      .map(
                        (e) => PopupMenuItem(
                          value: e['value'],
                          child: Text(e['title'] as String),
                        ),
                      )
                      .toList();
                },
              )
            : const SizedBox()
      ],
      title: props.title != null ? Text(props.title!) : null,
      backgroundColor: props.backgroundColor != null
          ? toColor(props.backgroundColor!)
          : null,
      elevation: props.elevation,
      centerTitle: props.centerTitle,
    );
  }
}
