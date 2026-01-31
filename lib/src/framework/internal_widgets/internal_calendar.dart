import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final bool yearSelectorEnabled;
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
    this.yearSelectorEnabled = false,
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

  Widget? _buildCustomHeaderWithYearSelector(
      BuildContext context, DateTime focusedDay) {
    if (!widget.yearSelectorEnabled || !widget.headersVisible) return null;

    final currentYear = _focusedDay.year;
    final currentMonth = DateFormat('MMMM').format(_focusedDay);
    final availableYears = _generateYearList(
      widget.firstDay.year,
      widget.lastDay.year,
    );

    return Container(
      padding: widget.headerStyle.headerPadding,
      decoration: widget.headerStyle.decoration,
      child: Row(
        mainAxisAlignment: widget.headerStyle.titleCentered
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: widget.headerStyle.leftChevronIcon,
            padding: widget.headerStyle.leftChevronPadding,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              setState(() {
                final newDate =
                    DateTime(_focusedDay.year, _focusedDay.month - 1);
                _focusedDay = newDate.isBefore(widget.firstDay)
                    ? widget.firstDay
                    : newDate;
              });
            },
          ),
          if (widget.headerStyle.titleCentered) Spacer(),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: widget.headerStyle.titleCentered
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currentMonth,
                  style: widget.headerStyle.titleTextStyle,
                ),
                const SizedBox(width: 8),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<int>(
                      value: currentYear,
                      style: widget.headerStyle.titleTextStyle,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: widget.headerStyle.titleTextStyle.color,
                      ),
                      dropdownColor: Colors.white,
                      menuMaxHeight: 200,
                      isDense: true,
                      items: availableYears.map((year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text(
                            year.toString(),
                            style: widget.headerStyle.titleTextStyle,
                          ),
                        );
                      }).toList(),
                      onChanged: (int? newYear) {
                        if (newYear != null) {
                          setState(() {
                            final lastDayOfMonth =
                                DateTime(newYear, _focusedDay.month + 1, 0).day;
                            var newDate = DateTime(
                              newYear,
                              _focusedDay.month,
                              _focusedDay.day > lastDayOfMonth
                                  ? lastDayOfMonth
                                  : _focusedDay.day,
                            );
                            if (newDate.isBefore(widget.firstDay)) {
                              _focusedDay = widget.firstDay;
                            } else if (newDate.isAfter(widget.lastDay)) {
                              _focusedDay = widget.lastDay;
                            } else {
                              _focusedDay = newDate;
                            }
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.headerStyle.titleCentered) Spacer(),
          IconButton(
            icon: widget.headerStyle.rightChevronIcon,
            padding: widget.headerStyle.rightChevronPadding,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              setState(() {
                final newDate =
                    DateTime(_focusedDay.year, _focusedDay.month + 1);
                _focusedDay =
                    newDate.isAfter(widget.lastDay) ? widget.lastDay : newDate;
              });
            },
          ),
        ],
      ),
    );
  }

  List<int> _generateYearList(int startYear, int endYear) {
    final years = <int>[];
    for (int year = startYear; year <= endYear; year++) {
      years.add(year);
    }
    return years;
  }

  @override
  Widget build(BuildContext context) {
    final calendar = TableCalendar<void>(
      focusedDay: _focusedDay,
      firstDay: widget.firstDay,
      lastDay: widget.lastDay,
      currentDay: widget.currentDay,
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat: widget.calendarFormat,
      rangeSelectionMode: _rangeSelectionMode,
      headerVisible: widget.yearSelectorEnabled ? false : widget.headersVisible,
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
        setState(() {
          if (focusedDay.isBefore(widget.firstDay)) {
            _focusedDay = widget.firstDay;
          } else if (focusedDay.isAfter(widget.lastDay)) {
            _focusedDay = widget.lastDay;
          } else {
            _focusedDay = focusedDay;
          }
        });
      },
    );

    if (widget.yearSelectorEnabled && widget.headersVisible) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCustomHeaderWithYearSelector(context, _focusedDay)!,
          calendar,
        ],
      );
    }

    return calendar;
  }
}
