import 'package:digia_ui/Utils/util_functions.dart';
import 'package:flutter/material.dart';

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

  static AppBar appbar(Map<String, dynamic> json) {
    final title = json['title'] as String?;
    final backgroundColor = json['backgroundColor'] as String?;
    final elevation = tryParseToDouble(json['elevation']);
    final centerTitle = json['centerTitle'] as bool? ?? false;
    // final leading = json['leading'] as Map<String, dynamic>?;
    // final actions = json['actions'] as List<dynamic>?;
    List<Widget> actions = [];
    if (json['actions'] != null) {
      for (final action in json['actions']['items']) {
        actions.add(
          IconButton(
            onPressed: () {
              print(action['title']);
            },
            icon: const Icon(Icons.search),
          ),
        );
      }
    }
    return AppBar(
      actions: [
        ...actions,
        json['popUpMenu'] != null
            ? PopupMenuButton(
                itemBuilder: (context) {
                  return (json['popUpMenu']['items'] as List<dynamic>)
                      .map(
                        (e) => PopupMenuItem(
                          onTap: () => print(e['title']),
                          value: e['value'],
                          child: Text(e['title'] as String),
                        ),
                      )
                      .toList();
                },
              )
            : const SizedBox()
        // TODO: (Ansh) confirm this, cannot return null here
      ],
      title: title != null ? Text(title) : null,
      backgroundColor:
          backgroundColor != null ? toColor(backgroundColor) : null,
      elevation: elevation,
      centerTitle: centerTitle,
    );
  }
}
