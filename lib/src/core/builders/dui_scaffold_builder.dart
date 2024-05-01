import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/components/dui_widget.dart';
import 'package:digia_ui/src/core/flutter_widgets.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../page/props/dui_widget_json_data.dart';

class DUIScaffoldBuilder extends DUIWidgetBuilder {
  DUIScaffoldBuilder({required super.data});

  static DUIScaffoldBuilder create(DUIWidgetJsonData data) {
    return DUIScaffoldBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final appBar = (data.children['appBar']?.firstOrNull).let((root) {
      if (root.type != 'fw/appBar') {
        return null;
      }

      return FW.appBar(root.props);
    });
    var fToast = FToast();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(30, 100),
        child: MouseRegion(
          onEnter: (d) {
            fToast.init(context);
            fToast.showToast(
              child: Text(
                  'Toast Appeared, widgetId=> ${data.children['appBar']?.first}'),
              toastDuration: const Duration(seconds: 4),
            );
          },
          onExit: (d) {
            fToast.removeCustomToast();
          },
          child: appBar!,
        ),
      ),
      body: data.children['body']?.firstOrNull.let((p0) {
        return SafeArea(child: DUIWidget(data: p0));
      }),
    );
  }
}
