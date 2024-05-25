import 'package:flutter/material.dart';

import '../../json_widget_builder.dart';
import '../../page/props/dui_widget_json_data.dart';
import 'dezerv_dial_pad_widget.dart';

class DUIDezervDialPadBuilder extends DUIWidgetBuilder {
  DUIDezervDialPadBuilder({required super.data});

  static DUIDezervDialPadBuilder? create(DUIWidgetJsonData data) {
    return DUIDezervDialPadBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return const DezervDialPad();
  }
}
