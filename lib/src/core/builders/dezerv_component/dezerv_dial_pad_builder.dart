import 'package:flutter/material.dart';

import '../../json_widget_builder.dart';
import '../../page/props/dui_widget_json_data.dart';
import 'dezerv_dial_pad_widget.dart';
import 'dezerv_dial_pad_widget_props.dart';

class DUIDezervDialPadBuilder extends DUIWidgetBuilder {
  DUIDezervDialPadBuilder(DUIWidgetJsonData data) : super(data: data);

  static DUIDezervDialPadBuilder? create(DUIWidgetJsonData data) {
    return DUIDezervDialPadBuilder(data);
  }

  @override
  Widget build(BuildContext context) {
    return DezervDialPad(
      props: data.props,
    );
  }
}
