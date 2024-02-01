import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/components/dui_widget.dart';
import 'package:digia_ui/src/core/flutter_widgets.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:flutter/material.dart';

import '../page/props/dui_widget_json_data.dart';

class DUIScaffoldBuilder extends DUIWidgetBuilder {
  DUIScaffoldBuilder({required super.data});

  static DUIScaffoldBuilder create(DUIWidgetJsonData data) {
    return DUIScaffoldBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final appBar = (data.children['appBar']?.first).let((root) {
      if (root.type != 'fw/appBar') {
        return null;
      }

      return FW.appBar(root.props);
    });

    return Scaffold(
      appBar: appBar,
      body: data.children['child']?.first.let((p0) {
        return SafeArea(child: DUIWidget(data: data));
      }),
    );
  }
}
