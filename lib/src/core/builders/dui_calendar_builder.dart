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
      // firstDay: data.props['firstDay'],
      // lastDay: data.props['lastDay'],
      focusedDay: data.props['focusedDay'],
      calendarFormat: data.props['calendarFormat'],
      currentDay: data.props['currentDay'],
      headersVisible: data.props['headersVisible'],
      daysOfWeekVisible: data.props['daysOfWeekVisible'],
      rowHeight: data.props['rowHeight'],
      daysOfWeekHeight: data.props['daysOfWeekHeight'],
      startingDayOfWeek: data.props['startingDayOfWeek'],
      pageJumpingEnabled: data.props['pageJumpingEnabled'],
      // shouldFillViewport: data.props['shouldFillViewport'],
      weekNumbersVisible: data.props['weekNumbersVisible'],
      rangeStartDay: data.props['rangeStartDay'],
      rangeEndDay: data.props['rangeEndDay'],
      selectionMode: data.props['selectionMode'],
      headerStyle: data.props['headerStyle'],
      daysOfWeekStyle: data.props['daysOfWeekStyle'],
      calendarStyle: data.props['calendarStyle'],
    );
  }
}
