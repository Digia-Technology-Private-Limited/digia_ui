import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/components/dui_widget.dart';
import 'package:digia_ui/src/components/floating_action_button/floating_action_button.dart';
import 'package:digia_ui/src/components/floating_action_button/floating_action_button_props.dart';
import 'package:digia_ui/src/core/flutter_widgets.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:flutter/material.dart';

import '../page/props/dui_widget_json_data.dart';

class DUIScaffoldBuilder extends DUIWidgetBuilder {
  final DUIFloatingActionButtonProps? duiFloatingActionButtonProps;
  DUIScaffoldBuilder({this.duiFloatingActionButtonProps, required super.data});

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

    final floatingActionButton =
        (data.children['floatingActionButton']?.firstOrNull).let((root) {
      if (root.type != 'digia/floatingActionButton') {
        return null;
      }

      return DUIFloatingActionButton.floatingActionButton(
          root.props, context, data);
    });

    final floatingActionButtonProps =
        (data.children['floatingActionButton']?.firstOrNull).let((root) {
      if (root.type != 'digia/floatingActionButton') {
        return null;
      }

      return DUIFloatingActionButtonProps.fromJson(root.props);
    });

    return Scaffold(
      appBar: appBar,
      body: data.children['body']?.firstOrNull.let((p0) {
        return SafeArea(child: DUIWidget(data: p0));
      }),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: DUIFloatingActionButtonLocation.fabLocation(
          floatingActionButtonProps),
    );
  }
}
