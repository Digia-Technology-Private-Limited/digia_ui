import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';
import 'dui_icon_builder.dart';

class DUICalendarBuilder extends DUIWidgetBuilder {
  DUICalendarBuilder({required super.data});

  static DUICalendarBuilder? create(DUIWidgetJsonData data) {
    return DUICalendarBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    // Calendar Setup
    DateTime kFirstDay = DateTime(1970, 1, 1);
    DateTime kLastDay = DateTime(2100, 1, 1);
    final firstDay = eval<String>(data.props['firstDay'], context: context);
    final lastDay = eval<String>(data.props['lastDay'], context: context);
    final focusedDay = eval<String>(data.props['focusedDay'], context: context);
    final calendarFormat =
        eval<String>(data.props['calendarFormat'], context: context);
    final currentDay = eval<String>(data.props['currentDay'], context: context);
    final headersVisible =
        eval<bool>(data.props['headersVisible'], context: context);
    final daysOfWeekVisible =
        eval<bool>(data.props['daysOfWeekVisible'], context: context);
    final rowHeight = eval<double>(data.props['rowHeight'], context: context);
    final daysOfWeekHeight =
        eval<double>(data.props['daysOfWeekHeight'], context: context);
    final startingDayOfWeek =
        eval<String>(data.props['startingDayOfWeek'], context: context);

    // Header Props
    final headerStyle = data.props['headerStyle'];
    final titleCentered =
        eval<bool>(headerStyle?['titleCentered'], context: context);
    final titleTextStyle = toTextStyle(
        DUITextStyle.fromJson(headerStyle?['titleTextStyle']), context);
    final leftChevronVisible =
        eval<bool>(headerStyle?['leftChevronVisible'], context: context);
    final leftChevronIcon =
        DUIIconBuilder.fromProps(props: headerStyle?['leftChevronIcon'])
            .build(context);
    final rightChevronVisible =
        eval<bool>(headerStyle?['rightChevronVisible'], context: context);
    final rightChevronIcon = DUIIconBuilder.fromProps(
      props: headerStyle?['rightChevronIcon'],
    ).build(context);

    // Days of the Week Props
    final daysOfWeekStyle = data.props['daysOfWeekStyle'];
    final weekdayStyle = toTextStyle(
        DUITextStyle.fromJson(daysOfWeekStyle?['weekdayStyle']), context);
    final weekendStyle = toTextStyle(
        DUITextStyle.fromJson(daysOfWeekStyle?['weekendStyle']), context);

    // Calendar Style Props
    final calendarStyle = data.props['calendarStyle'];
    final isTodayHighlighted =
        eval<bool>(calendarStyle?['isTodayHighlighted'], context: context);
    final outsideDaysVisible =
        eval<bool>(calendarStyle?['outsideDaysVisible'], context: context);
    final rangeHighlightColor =
        eval<String>(calendarStyle?['rangeHighlightColor'], context: context)
            .letIfTrue(toColor);

    // Range Selection Mode
    final rangeSelectionMode =
        eval<String>(data.props['rangeSelectionMode'], context: context);

    return TableCalendar(
      focusedDay:
          focusedDay != null ? DateTime.parse(focusedDay) : DateTime.now(),
      firstDay: firstDay != null ? DateTime.parse(firstDay) : kFirstDay,
      lastDay: lastDay != null ? DateTime.parse(lastDay) : kLastDay,
      currentDay:
          currentDay != null ? DateTime.parse(currentDay) : DateTime.now(),
      calendarFormat: calendarFormat == 'week'
          ? CalendarFormat.week
          : calendarFormat == '2 Weeks'
              ? CalendarFormat.twoWeeks
              : CalendarFormat.month,
      headerVisible: headersVisible ?? true,
      daysOfWeekVisible: daysOfWeekVisible ?? true,
      rowHeight: rowHeight ?? 52,
      daysOfWeekHeight: daysOfWeekHeight ?? 16,
      startingDayOfWeek: startingDayOfWeek == 'monday'
          ? StartingDayOfWeek.monday
          : StartingDayOfWeek.sunday,
      headerStyle: headerStyle != null
          ? HeaderStyle(
              formatButtonVisible: false,
              titleCentered: titleCentered ?? true,
              titleTextStyle: titleTextStyle ?? const TextStyle(fontSize: 17.0),
              leftChevronIcon: leftChevronIcon is SizedBox
                  ? const Icon(Icons.chevron_left)
                  : leftChevronIcon,
              rightChevronIcon: rightChevronIcon is SizedBox
                  ? const Icon(Icons.chevron_right)
                  : rightChevronIcon,
              leftChevronVisible: leftChevronVisible ?? true,
              rightChevronVisible: rightChevronVisible ?? true,
            )
          : const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
      daysOfWeekStyle: daysOfWeekStyle != null
          ? DaysOfWeekStyle(
              weekdayStyle:
                  weekdayStyle ?? const TextStyle(color: Color(0xFF4F4F4F)),
              weekendStyle:
                  weekendStyle ?? const TextStyle(color: Color(0xFF6A6A6A)),
            )
          : const DaysOfWeekStyle(),
      calendarStyle: calendarStyle != null
          ? CalendarStyle(
              isTodayHighlighted: isTodayHighlighted ?? true,
              outsideDaysVisible: outsideDaysVisible ?? true,
              rangeHighlightColor:
                  rangeHighlightColor ?? const Color(0xFFBBDDFF),
            )
          : const CalendarStyle(),
      rangeSelectionMode: rangeSelectionMode == 'Range'
          ? RangeSelectionMode.enforced
          : RangeSelectionMode.disabled,
      onDaySelected: (selectedDay, focusedDay) {
        print('Selected: $selectedDay');
        print('Focused: $focusedDay');
      },
      onRangeSelected: (start, end, focusedDay) {
        print('Range selected: $start - $end');
        print('Focused: $focusedDay');
      },
    );
  }
}
