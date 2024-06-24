import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../core/builders/dui_icon_builder.dart';
import '../DUIText/dui_text_style.dart';
import '../dui_base_stateful_widget.dart';

class DUICalendar extends BaseStatefulWidget {
  // final String? firstDay;
  // final String? lastDay;
  final String? focusedDay;
  final String? currentDay;
  final String? calendarFormat;
  final bool? headersVisible;
  final bool? daysOfWeekVisible;
  final double? rowHeight;
  final double? daysOfWeekHeight;
  final String? startingDayOfWeek;
  final bool? pageJumpingEnabled;
  // final bool? shouldFillViewport;
  final bool? weekNumbersVisible;
  final String? rangeStartDay;
  final String? rangeEndDay;
  final Map<String, dynamic>? selectionMode;
  final Map<String, dynamic>? headerStyle;
  final Map<String, dynamic>? daysOfWeekStyle;
  final Map<String, dynamic>? calendarStyle;

  const DUICalendar({
    super.key,
    super.varName,
    // this.firstDay,
    // this.lastDay,
    this.focusedDay,
    this.calendarFormat,
    this.currentDay,
    this.headersVisible,
    this.daysOfWeekVisible,
    this.rowHeight,
    this.daysOfWeekHeight,
    this.startingDayOfWeek,
    this.pageJumpingEnabled,
    // this.shouldFillViewport,
    this.weekNumbersVisible,
    this.rangeStartDay,
    this.rangeEndDay,
    this.selectionMode,
    this.headerStyle,
    this.daysOfWeekStyle,
    this.calendarStyle,
  });

  @override
  State<DUICalendar> createState() => _DUICalendarState();
}

class _DUICalendarState extends DUIWidgetState<DUICalendar> {
  ({String endIso, String startIso})? _selectedRangeISO;
  String? _selectedDateISO;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.focusedDay != null
        ? DateTime.parse(widget.focusedDay!)
        : DateTime.now();
    _selectedDateISO = widget.currentDay;

    _selectedRangeISO = ifNotNull2(widget.rangeStartDay, widget.rangeEndDay,
        (p0, p1) => (startIso: p0, endIso: p1));
    _rangeStart = _selectedRangeISO?.startIso.let((p0) => DateTime.parse(p0));
    _rangeEnd = _selectedRangeISO?.endIso.let((p0) => DateTime.parse(p0));
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _focusedDay = DateTime.now();
  //   _selectedDateISO = '';
  //   _selectedRangeISO = (startIso: '', endIso: '');
  // }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: widget.focusedDay != null
          ? DateTime.parse(widget.focusedDay!)
          : _focusedDay,
      firstDay: DateTime(1970, 1, 1),
      lastDay: DateTime(2100, 1, 1),
      // currentDay: widget.currentDay != null
      //     ? DateTime.parse(widget.currentDay!)
      //     : DateTime.now(),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat:
          _toCalendarFormat(widget.calendarFormat) ?? CalendarFormat.month,
      rangeSelectionMode: widget.selectionMode?['value'] == 'Range'
          ? RangeSelectionMode.enforced
          : RangeSelectionMode.disabled,
      headerVisible: widget.headersVisible ?? true,
      daysOfWeekVisible: widget.daysOfWeekVisible ?? true,
      rowHeight: widget.rowHeight ?? 52,
      daysOfWeekHeight: widget.daysOfWeekHeight ?? 16,
      startingDayOfWeek: widget.startingDayOfWeek == 'monday'
          ? StartingDayOfWeek.monday
          : StartingDayOfWeek.sunday,
      pageJumpingEnabled: widget.pageJumpingEnabled ?? false,
      // shouldFillViewport: widget.shouldFillViewport ?? false,
      weekNumbersVisible: widget.weekNumbersVisible ?? false,
      headerStyle: _toHeaderStyle(context),
      daysOfWeekStyle: daysOfWeekStyleFromJson(context),
      calendarStyle: calendarStyleFromJson(context),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _rangeStart = null;
            _rangeEnd = null;
            _selectedDateISO = selectedDay.toIso8601String();
          });
        }
      },
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _selectedDay = null;
          _focusedDay = focusedDay;
          _rangeStart = start;
          _rangeEnd = end;
        });
        _selectedRangeISO = (
          startIso: start!.toIso8601String(),
          endIso: end!.toIso8601String()
        );
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }

  // Header Props
  HeaderStyle _toHeaderStyle(BuildContext context) {
    final headerStyle = widget.headerStyle;
    late BoxShape shape; // toBoxShape
    headerStyle?['shape'] == 'circle'
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
    final headerColor = makeColor(headerStyle?['shape']['color']);
    final headerBorderColor = makeColor(headerStyle?['shape']['borderColor']);
    final headerBorderWidth = headerStyle?['shape']?['borderWidth'];
    final headerBorderRadius =
        DUIDecoder.toBorderRadius(headerStyle?['shape']?['borderRadius']);

    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: headerStyle?['titleCentered'] ?? true,
      titleTextStyle: titleTextStyle ?? const TextStyle(fontSize: 17.0),
      headerPadding: headerPadding,
      leftChevronIcon: leftChevronIcon is SizedBox
          ? const Icon(Icons.chevron_left)
          : leftChevronIcon,
      leftChevronPadding: leftChevronPadding,
      rightChevronIcon: rightChevronIcon is SizedBox
          ? const Icon(Icons.chevron_right)
          : rightChevronIcon,
      rightChevronPadding: rightChevronPadding,
      decoration: BoxDecoration(
        color: headerColor,
        border: headerBorderColor != null
            ? Border.all(
                color: headerBorderColor,
                width: NumDecoder.toDoubleOrDefault(headerBorderWidth,
                    defaultValue: 1.0),
              )
            : null,
        borderRadius: shape == BoxShape.circle ? null : headerBorderRadius,
        shape: shape,
      ),
    );
  }

  // Days of the Week Props
  DaysOfWeekStyle daysOfWeekStyleFromJson(BuildContext context) {
    final daysOfWeekStyle = widget.daysOfWeekStyle;

    late BoxShape shape;
    daysOfWeekStyle?['shape'] == 'circle'
        ? shape = BoxShape.circle
        : shape = BoxShape.rectangle;

    final weekdayStyle = toTextStyle(
        DUITextStyle.fromJson(daysOfWeekStyle?['weekdayStyle']), context);
    final weekendStyle = toTextStyle(
        DUITextStyle.fromJson(daysOfWeekStyle?['weekendStyle']), context);
    final daysOfWeekColor = makeColor(daysOfWeekStyle?['color']);
    final daysOfWeekBorderColor = makeColor(daysOfWeekStyle?['borderColor']);
    final daysOfWeekBorderWidth = daysOfWeekStyle?['borderWidth'];
    final daysOfWeekBorderRadius =
        DUIDecoder.toBorderRadius(daysOfWeekStyle?['borderRadius']);

    return DaysOfWeekStyle(
      weekdayStyle: weekdayStyle ?? const TextStyle(color: Color(0xFF4F4F4F)),
      weekendStyle: weekendStyle ?? const TextStyle(color: Color(0xFF6A6A6A)),
      decoration: BoxDecoration(
        color: daysOfWeekColor,
        border: daysOfWeekBorderColor != null
            ? Border.all(
                color: daysOfWeekBorderColor,
                width: NumDecoder.toDoubleOrDefault(daysOfWeekBorderWidth,
                    defaultValue: 1.0),
              )
            : null,
        borderRadius: shape == BoxShape.circle ? null : daysOfWeekBorderRadius,
        shape: shape,
      ),
    );
  }

  // Calendar Style Props
  CalendarStyle calendarStyleFromJson(BuildContext context) {
    final calendarStyle = widget.calendarStyle;
    // final cellPadding = DUIDecoder.toEdgeInsets(calendarStyle?['cellPadding']);
    // final cellAlignment =
    //     DUIDecoder.toAlignment(calendarStyle?['cellAlignment'] ?? 'center');
    final rangeHighlightScale = calendarStyle?['rangeHighlightScale'] ?? 1.0;
    final rangeHighlightColor =
        makeColor(calendarStyle?['rangeHighlightColor']);
    final outsideDaysVisible = calendarStyle?['outsideDaysVisible'];
    final isTodayHighlighted = calendarStyle?['isTodayHighlighted'];
    final tableBorderColor =
        makeColor(calendarStyle?['tableBorderColor']) ?? Colors.black;
    final tableBorderWidth = calendarStyle?['tableBorderWidth'];
    final tableBorder = tableBorderWidth != null
        ? TableBorder(
            top: BorderSide(
              color: tableBorderColor,
              width: NumDecoder.toDoubleOrDefault(tableBorderWidth,
                  defaultValue: 1.0),
            ),
            bottom: BorderSide(
              color: tableBorderColor,
              width: NumDecoder.toDoubleOrDefault(tableBorderWidth,
                  defaultValue: 1.0),
            ),
            left: BorderSide(
              color: tableBorderColor,
              width: NumDecoder.toDoubleOrDefault(tableBorderWidth,
                  defaultValue: 1.0),
            ),
            right: BorderSide(
              color: tableBorderColor,
              width: NumDecoder.toDoubleOrDefault(tableBorderWidth,
                  defaultValue: 1.0),
            ),
          )
        : null;
    final tablePadding =
        DUIDecoder.toEdgeInsets(calendarStyle?['tablePadding']);

    return CalendarStyle(
      // cellPadding: cellPadding,
      // cellAlignment:
      //     cellAlignment?.resolve(TextDirection.ltr) ?? Alignment.center,
      rangeHighlightScale: rangeHighlightScale,
      rangeHighlightColor: rangeHighlightColor ?? const Color(0xFFBBDDFF),
      outsideDaysVisible: outsideDaysVisible ?? true,
      isTodayHighlighted: isTodayHighlighted ?? true,
      tableBorder: tableBorder ?? const TableBorder(),
      tablePadding: tablePadding,
    );
  }

  @override
  Map<String, Function> getVariables() {
    return {
      'selectedDate': () => _selectedDateISO,
      'selectedRange': () => ifNotNull(
          _selectedRangeISO,
          (p0) => {
                'start': p0.startIso,
                'end': p0.endIso,
              })
    };
  }
}

CalendarFormat? _toCalendarFormat(dynamic value) => switch (value) {
      'week' => CalendarFormat.week,
      'twoWeeks' => CalendarFormat.twoWeeks,
      'month' => CalendarFormat.month,
      _ => null
    };
