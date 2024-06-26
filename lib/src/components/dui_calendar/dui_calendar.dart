import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Utils/basic_shared_utils/date_decoder.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../core/builders/dui_icon_builder.dart';
import '../../core/evaluator.dart';
import '../DUIText/dui_text_style.dart';
import '../dui_base_stateful_widget.dart';

class DUICalendar extends BaseStatefulWidget {
  final Map<String, dynamic> props;

  const DUICalendar({
    super.key,
    required super.varName,
    required this.props,
  });

  @override
  State<DUICalendar> createState() => _DUICalendarState();
}

class _DUICalendarState extends DUIWidgetState<DUICalendar> {
  DateTime _firstDay = DateTime(1970, 1, 1);
  DateTime _lastDay = DateTime(2100, 1, 1);
  DateTime? _currentDay;

  CalendarFormat calendarFormat = CalendarFormat.month;
  bool headersVisible = true;
  bool daysOfWeekVisible = true;
  double rowHeight = 52.0;
  double daysOfWeekHeight = 16.0;
  StartingDayOfWeek startingDayOfWeek = StartingDayOfWeek.sunday;
  bool pageJumpingEnabled = false;
  bool shouldFillViewport = false;
  bool weekNumbersVisible = false;

  Map<String, dynamic>? headerStyle;
  Map<String, dynamic>? daysOfWeekStyle;
  Map<String, dynamic>? calendarStyle;

  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.disabled;
  DateTime? _selectedRangeStart;
  DateTime? _selectedRangeEnd;
  DateTime? _selectedDate;

  late DateTime _focusedDay;

  @override
  void initState() {
    _firstDay = DateDecoder.toDate(widget.props['firstDay']) ?? _firstDay;
    _lastDay = DateDecoder.toDate(widget.props['lastDay']) ?? _lastDay;
    _currentDay = DateDecoder.toDate(widget.props['currentDay']);
    calendarFormat =
        _toCalendarFormat(widget.props['calendarFormat']) ?? calendarFormat;
    headersVisible =
        NumDecoder.toBool(widget.props['headersVisible']) ?? headersVisible;
    daysOfWeekVisible = NumDecoder.toBool(widget.props['daysOfWeekVisible']) ??
        daysOfWeekVisible;
    rowHeight = NumDecoder.toDouble(widget.props['rowHeight']) ?? rowHeight;
    daysOfWeekHeight = NumDecoder.toDouble(widget.props['daysOfWeekHeight']) ??
        daysOfWeekHeight;
    startingDayOfWeek =
        _toStartingDayOfWeek(widget.props['startingDayOfWeek']) ??
            startingDayOfWeek;
    pageJumpingEnabled =
        NumDecoder.toBool(widget.props['pageJumpingEnabled']) ??
            pageJumpingEnabled;
    shouldFillViewport =
        NumDecoder.toBool(widget.props['shouldFillViewport']) ??
            shouldFillViewport;
    weekNumbersVisible =
        NumDecoder.toBool(widget.props['weekNumbersVisible']) ??
            weekNumbersVisible;

    headerStyle = widget.props['headerStyle'];
    daysOfWeekStyle = widget.props['daysOfWeekStyle'];
    calendarStyle = widget.props['calendarStyle'];

    rangeSelectionMode =
        _toRangeSelectionMode(widget.props['rangeSelectionMode']) ??
            rangeSelectionMode;
    if (rangeSelectionMode == RangeSelectionMode.enforced) {
      final selectedRange = ifNotNull2(
          DateDecoder.toDate(eval<String>(
              widget.props.valueFor(
                  keyPath: 'rangeSelectionMode.rangeStartDateInitialValue'),
              context: context)),
          DateDecoder.toDate(eval<String>(
              widget.props.valueFor(
                  keyPath: 'rangeSelectionMode.rangeEndDateInitialValue'),
              context: context)),
          (p0, p1) => (start: p0, end: p1));

      _selectedRangeStart = selectedRange?.start;
      _selectedRangeEnd = selectedRange?.end;

      _focusedDay = _selectedRangeStart ?? DateTime.now();
    }
    if (rangeSelectionMode == RangeSelectionMode.disabled) {
      _selectedDate = ifNotNull(
          DateDecoder.toDate(eval<String>(
              widget.props.valueFor(keyPath: 'rangeSelectionMode.selectedDate'),
              context: context)),
          (p0) => p0);

      _focusedDay = _selectedDate ?? DateTime.now();
    }
    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant DUICalendar oldWidget) {
  //   if (_selectedDate != _focusedDay) {
  //     _focusedDay = _selectedDate ?? _focusedDay;
  //     _selectedDate = DateDecoder.toDate(widget.props['selectedDate']);
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: _firstDay,
      lastDay: _lastDay,
      currentDay: _currentDay,
      rangeStartDay: _selectedRangeStart,
      rangeEndDay: _selectedRangeEnd,
      calendarFormat: calendarFormat,
      rangeSelectionMode: rangeSelectionMode,
      headerVisible: headersVisible,
      daysOfWeekVisible: daysOfWeekVisible,
      rowHeight: rowHeight,
      daysOfWeekHeight: daysOfWeekHeight,
      startingDayOfWeek: startingDayOfWeek,
      pageJumpingEnabled: pageJumpingEnabled,
      shouldFillViewport: shouldFillViewport,
      weekNumbersVisible: weekNumbersVisible,
      headerStyle: _toHeaderStyle(context),
      daysOfWeekStyle: _toDaysOfWeekStyleFromJson(context),
      calendarStyle: _toCalendarStyleFromJson(context),
      selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDate, selectedDay)) {
          setState(() {
            _selectedDate = selectedDay;
            _focusedDay = focusedDay;
            _selectedRangeStart = null;
            _selectedRangeEnd = null;
          });
        }
      },
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _selectedRangeStart = start;
          _selectedRangeEnd = end;
          _selectedDate = null;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }

  // Header Props
  HeaderStyle _toHeaderStyle(BuildContext context) {
    if (headerStyle == null ||
        headerStyle?['leftChevronIcon']['iconData'] == null) {
      return const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: false,
        titleTextStyle: TextStyle(fontSize: 17.0),
        headerPadding: EdgeInsets.symmetric(vertical: 8.0),
        leftChevronIcon: Icon(Icons.chevron_left),
        leftChevronPadding: EdgeInsets.all(12.0),
        rightChevronIcon: Icon(Icons.chevron_right),
        rightChevronPadding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(),
      );
    }

    bool titleCentered =
        NumDecoder.toBool(headerStyle?['titleCentered']) ?? false;
    BoxShape? shape = _toBoxShape(headerStyle?['shape']);
    TextStyle titleTextStyle = toTextStyle(
            DUITextStyle.fromJson(headerStyle?['titleTextStyle']), context) ??
        const TextStyle(fontSize: 17.0);
    EdgeInsets? headerPadding =
        DUIDecoder.toEdgeInsets(headerStyle?['headerPadding']);
    Widget? leftChevronIcon =
        DUIIconBuilder.fromProps(props: headerStyle?['leftChevronIcon'])
                ?.build(context) ??
            DUIIconBuilder.emptyIconWidget();
    EdgeInsets? leftChevronPadding =
        DUIDecoder.toEdgeInsets(headerStyle?['leftChevronPadding']);
    Widget? rightChevronIcon =
        DUIIconBuilder.fromProps(props: headerStyle?['rightChevronIcon'])
                ?.build(context) ??
            DUIIconBuilder.emptyIconWidget();
    EdgeInsets? rightChevronPadding =
        DUIDecoder.toEdgeInsets(headerStyle?['rightChevronPadding']);
    Color? headerColor = makeColor(headerStyle?['shape']['color']);
    Color headerBorderColor = makeColor(headerStyle?['shape']['borderColor']) ??
        const Color(0xFF000000);
    double headerBorderWidth =
        NumDecoder.toDouble(headerStyle?['shape']['borderWidth']) ?? 1.0;
    BorderRadius? headerBorderRadius =
        DUIDecoder.toBorderRadius(headerStyle?['shape']?['borderRadius']);

    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: titleCentered,
      titleTextStyle: titleTextStyle,
      headerPadding: headerPadding,
      leftChevronIcon: leftChevronIcon,
      leftChevronPadding: leftChevronPadding,
      rightChevronIcon: rightChevronIcon,
      rightChevronPadding: rightChevronPadding,
      decoration: BoxDecoration(
        color: headerColor,
        border: Border.all(
          color: headerBorderColor,
          width: headerBorderWidth,
        ),
        borderRadius: shape == BoxShape.circle ? null : headerBorderRadius,
        shape: shape,
      ),
    );
  }

  // Days of the Week Props
  DaysOfWeekStyle _toDaysOfWeekStyleFromJson(BuildContext context) {
    if (daysOfWeekStyle == null) {
      return const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Color(0xFF4F4F4F)),
        weekendStyle: TextStyle(color: Color(0xFF6A6A6A)),
        decoration: BoxDecoration(),
      );
    }

    BoxShape? shape = _toBoxShape(daysOfWeekStyle?['shape']);
    TextStyle weekdayStyle = toTextStyle(
            DUITextStyle.fromJson(daysOfWeekStyle?['weekdayStyle']), context) ??
        const TextStyle(color: Color(0xFF4F4F4F));
    TextStyle weekendStyle = toTextStyle(
            DUITextStyle.fromJson(daysOfWeekStyle?['weekendStyle']), context) ??
        const TextStyle(color: Color(0xFF6A6A6A));
    Color? daysOfWeekColor = makeColor(daysOfWeekStyle?['shape']['color']);
    Color daysOfWeekBorderColor =
        makeColor(daysOfWeekStyle?['shape']['borderColor']) ??
            const Color(0xFF000000);
    double daysOfWeekBorderWidth =
        NumDecoder.toDouble(daysOfWeekStyle?['shape']['borderWidth']) ?? 1.0;
    BorderRadius? daysOfWeekBorderRadius =
        DUIDecoder.toBorderRadius(daysOfWeekStyle?['shape']['borderRadius']);

    return DaysOfWeekStyle(
      weekdayStyle: weekdayStyle,
      weekendStyle: weekendStyle,
      decoration: BoxDecoration(
        color: daysOfWeekColor,
        border: Border.all(
          color: daysOfWeekBorderColor,
          width: daysOfWeekBorderWidth,
        ),
        borderRadius: shape == BoxShape.circle ? null : daysOfWeekBorderRadius,
        shape: shape,
      ),
    );
  }

  // Calendar Style Props
  CalendarStyle _toCalendarStyleFromJson(BuildContext context) {
    if (calendarStyle == null) {
      return const CalendarStyle(
        rangeHighlightScale: 1.0,
        rangeHighlightColor: Color(0xFFBBDDFF),
        outsideDaysVisible: true,
        isTodayHighlighted: true,
        tableBorder: TableBorder(),
        tablePadding: EdgeInsets.all(0),
      );
    }

    double? rangeHighlightScale =
        NumDecoder.toDouble(calendarStyle?['rangeHighlightScale']);
    Color? rangeHighlightColor =
        makeColor(calendarStyle?['rangeHighlightColor']);
    bool? outsideDaysVisible =
        NumDecoder.toBool(calendarStyle?['outsideDaysVisible']);
    bool? isTodayHighlighted =
        NumDecoder.toBool(calendarStyle?['isTodayHighlighted']);
    Color? tableBorderColor =
        makeColor(calendarStyle?['tableBorderColor']) ?? Colors.black;
    double? tableBorderWidth =
        NumDecoder.toDouble(calendarStyle?['tableBorderWidth']);
    BorderStyle? tableBorderStyle =
        _toBorderStyle(calendarStyle?['tableBorderStyle']);
    BorderRadius? tableBorderRadius =
        DUIDecoder.toBorderRadius(calendarStyle?['tableBorderRadius']);
    TableBorder? tableBorder = _toTableBorder({
      'color': tableBorderColor,
      'width': tableBorderWidth,
      'style': tableBorderStyle,
      'borderRadius': tableBorderRadius,
    });
    EdgeInsets? tablePadding =
        DUIDecoder.toEdgeInsets(calendarStyle?['tablePadding']);

    return CalendarStyle(
      rangeHighlightScale: rangeHighlightScale ?? 1.0,
      rangeHighlightColor: rangeHighlightColor ?? const Color(0xFFBBDDFF),
      outsideDaysVisible: outsideDaysVisible ?? true,
      isTodayHighlighted: isTodayHighlighted ?? true,
      tableBorder: tableBorder ?? const TableBorder(),
      tablePadding: tablePadding,
    );
  }

  // Utils
  CalendarFormat? _toCalendarFormat(dynamic value) => switch (value) {
        'week' => CalendarFormat.week,
        'twoWeeks' => CalendarFormat.twoWeeks,
        'month' => CalendarFormat.month,
        _ => null
      };

  StartingDayOfWeek? _toStartingDayOfWeek(dynamic value) => switch (value) {
        'monday' => StartingDayOfWeek.monday,
        'sunday' => StartingDayOfWeek.sunday,
        _ => null
      };

  RangeSelectionMode? _toRangeSelectionMode(dynamic mode) {
    if (mode['value'] == 'singleDate') {
      return RangeSelectionMode.disabled;
    } else if (mode['value'] == 'range') {
      return RangeSelectionMode.enforced;
    }

    return RangeSelectionMode.disabled;
  }

  BoxShape _toBoxShape(dynamic value) => switch (value) {
        'circle' => BoxShape.circle,
        'rectangle' => BoxShape.rectangle,
        _ => BoxShape.rectangle
      };

  TableBorder? _toTableBorder(dynamic value) {
    if (value == null) return null;
    return TableBorder.all(
      color: makeColor(value['color']) ?? Colors.transparent,
      width: NumDecoder.toDouble(value['width']) ?? 1.0,
      style: _toBorderStyle(value['style']),
      borderRadius: DUIDecoder.toBorderRadius(value['borderRadius']),
    );
  }

  BorderStyle _toBorderStyle(dynamic value) => switch (value) {
        'none' => BorderStyle.none,
        'solid' => BorderStyle.solid,
        _ => BorderStyle.solid
      };

  // State Management
  @override
  Map<String, Function> getVariables() {
    return {
      'selectedDate': () => _selectedDate?.toIso8601String(),
      'selectedRange': () => ifNotNull2(
          _selectedRangeStart,
          _selectedRangeEnd,
          (p0, p1) => {
                'start': p0.toIso8601String(),
                'end': p1.toIso8601String(),
              })
    };
  }
}
