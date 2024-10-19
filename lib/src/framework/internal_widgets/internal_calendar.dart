import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class InternalCalendar extends StatefulWidget {
  DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime? currentDay;
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
  void Function(DateTime selectedDate, DateTime focusedDay)? onDateSelected;
  void Function(DateTime? start, DateTime? end, DateTime focusedDay)?
      onRangeSelected;

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
    required this.onDateSelected,
    required this.onRangeSelected,
  });

  @override
  State<InternalCalendar> createState() => _InternalCalendarState();
}

class _InternalCalendarState extends State<InternalCalendar> {
  late DateTime _focusedDay;
  late RangeSelectionMode _rangeSelectionMode;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.focusedDay;
    _rangeSelectionMode = widget.rangeSelectionMode;
    _selectedDay = widget.selectedDate;
    _rangeStart = widget.selectedRangeStart;
    _rangeEnd = widget.selectedRangeEnd;
  }

  @override
  void didUpdateWidget(covariant InternalCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_focusedDay != widget.focusedDay) {
      _focusedDay = widget.focusedDay;
    }
    if (_rangeSelectionMode != widget.rangeSelectionMode) {
      _rangeSelectionMode = widget.rangeSelectionMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: widget.firstDay,
      lastDay: widget.lastDay,
      currentDay: widget.currentDay,
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat: widget.calendarFormat,
      rangeSelectionMode: _rangeSelectionMode,
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
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _rangeStart = null;
            _rangeEnd = null;
          });
          widget.onDateSelected?.call(selectedDay, focusedDay);
        }
      },
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _selectedDay = null;
          _focusedDay = focusedDay;
          _rangeStart = start;
          _rangeEnd = end;
        });
        widget.onRangeSelected?.call(start, end, focusedDay);
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
