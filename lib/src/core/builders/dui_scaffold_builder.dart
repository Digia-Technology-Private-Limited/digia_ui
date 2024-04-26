import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../components/dui_widget.dart';
import '../flutter_widgets.dart';
import '../json_widget_builder.dart';
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

    return Scaffold(
      appBar: appBar,
      body: data.children['body']?.firstOrNull.let((p0) {
        return SafeArea(child: DUIWidget(data: p0));
      }),
    );
  }
}
