import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class InternalCalendar extends StatefulWidget {
  DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime currentDay;
  final DateTime? rangeStartDay;
  final DateTime? rangeEndDay;
  final CalendarFormat calendarFormat;
  final RangeSelectionMode rangeSelectionMode;
  final bool headersVisible;
  final bool daysOfWeekVisible;
  final double rowHeight;
  final double daysOfWeekHeight;
  final StartingDayOfWeek startingDayOfWeek;
  final bool pageJumpingEnabled;
  final bool shouldFillViewport;
  final bool weekNumbersVisible;
  final HeaderStyle headerStyle;
  final DaysOfWeekStyle daysOfWeekStyle;
  final CalendarStyle calendarStyle;
  DateTime? selectedDate;
  DateTime? selectedRangeStart;
  DateTime? selectedRangeEnd;

  InternalCalendar({
    super.key,
    required this.focusedDay,
    required this.firstDay,
    required this.lastDay,
    required this.currentDay,
    required this.rangeStartDay,
    required this.rangeEndDay,
    required this.calendarFormat,
    required this.rangeSelectionMode,
    required this.headersVisible,
    required this.daysOfWeekVisible,
    required this.rowHeight,
    required this.daysOfWeekHeight,
    required this.startingDayOfWeek,
    required this.pageJumpingEnabled,
    required this.shouldFillViewport,
    required this.weekNumbersVisible,
    required this.headerStyle,
    required this.daysOfWeekStyle,
    required this.calendarStyle,
    required this.selectedDate,
    required this.selectedRangeStart,
    required this.selectedRangeEnd,
  });

  @override
  State<InternalCalendar> createState() => _InternalCalendarState();
}

class _InternalCalendarState extends State<InternalCalendar> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: widget.focusedDay,
      firstDay: widget.firstDay,
      lastDay: widget.lastDay,
      currentDay: widget.currentDay,
      rangeStartDay: widget.rangeStartDay,
      rangeEndDay: widget.rangeEndDay,
      calendarFormat: widget.calendarFormat,
      rangeSelectionMode: widget.rangeSelectionMode,
      headerVisible: widget.headersVisible,
      daysOfWeekVisible: widget.daysOfWeekVisible,
      rowHeight: widget.rowHeight,
      daysOfWeekHeight: widget.daysOfWeekHeight,
      startingDayOfWeek: widget.startingDayOfWeek,
      pageJumpingEnabled: widget.pageJumpingEnabled,
      shouldFillViewport: widget.shouldFillViewport,
      weekNumbersVisible: widget.weekNumbersVisible,
      headerStyle: widget.headerStyle,
      daysOfWeekStyle: widget.daysOfWeekStyle,
      calendarStyle: widget.calendarStyle,
      selectedDayPredicate: (day) => isSameDay(widget.selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(widget.selectedDate, selectedDay)) {
          setState(() {
            widget.selectedDate = selectedDay;
            widget.focusedDay = focusedDay;
            widget.selectedRangeStart = null;
            widget.selectedRangeEnd = null;
          });
        }
      },
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          widget.selectedRangeStart = start;
          widget.selectedRangeEnd = end;
          widget.selectedDate = null;
          widget.focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        widget.focusedDay = focusedDay;
      },
    );
  }
}
