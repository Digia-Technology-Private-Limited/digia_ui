import 'package:digia_ui/components/dropdown/dui_dropdown.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:flutter/material.dart';

import '../../components/dropdown/dui_dropdown_props.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIDropdownBuilder extends DUIWidgetBuilder {
  DUIDropdownBuilder({required super.data});

  static DUIDropdownBuilder create(DUIWidgetJsonData data) {
    return DUIDropdownBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIDropdown(DUIDropdownProps.fromJson(data.props));
  }
}
