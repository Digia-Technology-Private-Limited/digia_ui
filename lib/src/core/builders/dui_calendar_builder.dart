import 'package:flutter/material.dart';
import '../../components/dui_calendar/dui_calendar.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUICalendarBuilder extends DUIWidgetBuilder {
  DUICalendarBuilder({required super.data});

  static DUICalendarBuilder? create(DUIWidgetJsonData data) {
    return DUICalendarBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUICalendar(
      varName: data.varName,
      props: data.props,
    );
  }
}
