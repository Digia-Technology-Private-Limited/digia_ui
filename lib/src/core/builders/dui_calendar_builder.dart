import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
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
    final firstDay = data.props['firstDay'];
    final lastDay = data.props['lastDay'];
    final focusedDay = data.props['focusedDay'];
    final calendarFormat = data.props['calendarFormat'];
    final currentDay = data.props['currentDay'];
    final headersVisible = data.props['headersVisible'];
    final daysOfWeekVisible = data.props['daysOfWeekVisible'];
    final rowHeight = data.props['rowHeight'];
    final daysOfWeekHeight = data.props['daysOfWeekHeight'];
    final startingDayOfWeek = data.props['startingDayOfWeek'];
    final pageJumpingEnabled = data.props['pageJumpingEnabled'];
    final shouldFillViewport = data.props['shouldFillViewport'];
    final weekNumbersVisible = data.props['weekNumbersVisible'];

    // Range Props
    final rangeStartDay = data.props['rangeStartDay'];
    final rangeEndDay = data.props['rangeEndDay'];

    // Header Props
    HeaderStyle headerStyleFromJson(BuildContext context) {
      final headerStyle = data.props['headerStyle'];
      late BoxShape shape;
      headerStyle['shape'] == 'circle'
          ? shape = BoxShape.circle
          : shape = BoxShape.rectangle;
      final titleTextStyle = toTextStyle(
          DUITextStyle.fromJson(headerStyle?['titleTextStyle']), context);
      final headerPadding =
          DUIDecoder.toEdgeInsets(headerStyle?['headerPadding']);
      final leftChevronIcon =
          DUIIconBuilder.fromProps(props: headerStyle?['leftChevronIcon'])
              .build(context);
      final leftChevronPadding =
          DUIDecoder.toEdgeInsets(headerStyle?['leftChevronPadding']);
      final rightChevronIcon =
          DUIIconBuilder.fromProps(props: headerStyle?['rightChevronIcon'])
              .build(context);
      final rightChevronPadding =
          DUIDecoder.toEdgeInsets(headerStyle?['rightChevronPadding']);
      final headerColor =
          headerStyle?['decoration']?['color'].letIfTrue(toColor);
      final headerBorderColor =
          headerStyle?['decoration']?['borderColor'].letIfTrue(toColor);
      final headerBorderWidth =
          headerStyle?['decoration']?['borderWidth'] ?? 1.0;
      final headerBorderRadius = DUIDecoder.toBorderRadius(
          headerStyle?['decoration']?['borderRadius']);

      return HeaderStyle(
        formatButtonVisible: false,
        titleCentered: headerStyle?['titleCentered'] ?? true,
        titleTextStyle: titleTextStyle ?? const TextStyle(fontSize: 17.0),
        headerPadding: headerPadding,
        leftChevronIcon: leftChevronIcon,
        leftChevronPadding: leftChevronPadding,
        rightChevronIcon: rightChevronIcon,
        rightChevronPadding: rightChevronPadding,
        decoration: BoxDecoration(
          color: headerColor,
          border: Border.all(
            color: headerBorderColor ?? Colors.black,
            width: headerBorderWidth,
          ),
          borderRadius: shape == BoxShape.circle ? null : headerBorderRadius,
          shape: shape,
        ),
      );
    }

    // Days of the Week Props
    DaysOfWeekStyle daysOfWeekStyleFromJson(BuildContext context) {
      final daysOfWeekStyle = data.props['daysOfWeekStyle'];

      late BoxShape shape;
      daysOfWeekStyle['shape'] == 'circle'
          ? shape = BoxShape.circle
          : shape = BoxShape.rectangle;

      final weekdayStyle = toTextStyle(
          DUITextStyle.fromJson(daysOfWeekStyle?['weekdayStyle']), context);
      final weekendStyle = toTextStyle(
          DUITextStyle.fromJson(daysOfWeekStyle?['weekendStyle']), context);
      final daysOfWeekColor =
          daysOfWeekStyle?['decoration']?['color'].letIfTrue(toColor);
      final daysOfWeekBorderColor =
          daysOfWeekStyle?['decoration']?['borderColor'].letIfTrue(toColor);
      final daysOfWeekBorderWidth =
          daysOfWeekStyle?['decoration']?['borderWidth'] ?? 1.0;
      final daysOfWeekBorderRadius = DUIDecoder.toBorderRadius(
          daysOfWeekStyle?['decoration']?['borderRadius']);

      return DaysOfWeekStyle(
        weekdayStyle: weekdayStyle ?? const TextStyle(color: Color(0xFF4F4F4F)),
        weekendStyle: weekendStyle ?? const TextStyle(color: Color(0xFF6A6A6A)),
        decoration: BoxDecoration(
          color: daysOfWeekColor,
          border: Border.all(
            color: daysOfWeekBorderColor ?? Colors.black,
            width: daysOfWeekBorderWidth,
          ),
          borderRadius:
              shape == BoxShape.circle ? null : daysOfWeekBorderRadius,
          shape: shape,
        ),
      );
    }

    // Calendar Style Props
    CalendarStyle calendarStyleFromJson(BuildContext context) {
      final calendarStyle = data.props['calendarStyle'];
      final cellPadding =
          DUIDecoder.toEdgeInsets(calendarStyle?['cellPadding']);
      final cellAlignment =
          DUIDecoder.toAlignment(calendarStyle?['cellAlignment'] ?? 'center');
      final rangeHighlightScale = calendarStyle?['rangeHighlightScale'] ?? 1.0;
      final rangeHighlightColor = calendarStyle?['rangeHighlightColor']
          .letIfTrue(toColor, defaultValue: const Color(0xFFBBDDFF));
      final outsideDaysVisible = calendarStyle?['outsideDaysVisible'];
      final isTodayHighlighted = calendarStyle?['isTodayHighlighted'];
      final tableBorderColor =
          calendarStyle?['tableBorder']?['color'].letIfTrue(toColor);
      final tableBorderWidth = calendarStyle?['tableBorder']?['width'] ?? 1.0;
      final tableBorder = TableBorder(
        top: BorderSide(
          color: tableBorderColor ?? Colors.black,
          width: tableBorderWidth,
        ),
        bottom: BorderSide(
          color: tableBorderColor ?? Colors.black,
          width: tableBorderWidth,
        ),
        left: BorderSide(
          color: tableBorderColor ?? Colors.black,
          width: tableBorderWidth,
        ),
        right: BorderSide(
          color: tableBorderColor ?? Colors.black,
          width: tableBorderWidth,
        ),
      );
      final tablePadding =
          DUIDecoder.toEdgeInsets(calendarStyle?['tablePadding']);

      return CalendarStyle(
        cellPadding: cellPadding,
        cellAlignment:
            cellAlignment?.resolve(TextDirection.ltr) ?? Alignment.center,
        rangeHighlightScale: rangeHighlightScale,
        rangeHighlightColor: rangeHighlightColor,
        outsideDaysVisible: outsideDaysVisible ?? true,
        isTodayHighlighted: isTodayHighlighted ?? true,
        tableBorder: tableBorder,
        tablePadding: tablePadding,
      );
    }

    // Range Selection Mode
    final selectionMode = data.props['rangeSelectionMode'];

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
      rangeSelectionMode: selectionMode == 'Range'
          ? RangeSelectionMode.enforced
          : RangeSelectionMode.disabled,
      rangeStartDay: rangeStartDay != null
          ? DateTime.parse(rangeStartDay)
          : DateTime.now(),
      rangeEndDay: rangeEndDay != null
          ? DateTime.parse(rangeEndDay)
          : DateTime.now().add(const Duration(days: 7)),
      headerVisible: headersVisible ?? true,
      daysOfWeekVisible: daysOfWeekVisible ?? true,
      rowHeight: rowHeight ?? 52,
      daysOfWeekHeight: daysOfWeekHeight ?? 16,
      startingDayOfWeek: startingDayOfWeek == 'monday'
          ? StartingDayOfWeek.monday
          : StartingDayOfWeek.sunday,
      headerStyle: headerStyleFromJson(context),
      daysOfWeekStyle: daysOfWeekStyleFromJson(context),
      calendarStyle: calendarStyleFromJson(context),
      pageJumpingEnabled: pageJumpingEnabled ?? false,
      shouldFillViewport: shouldFillViewport ?? false,
      weekNumbersVisible: weekNumbersVisible ?? false,
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
