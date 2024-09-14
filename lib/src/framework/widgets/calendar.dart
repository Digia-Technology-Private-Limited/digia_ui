import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../Utils/basic_shared_utils/date_decoder.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_calendar.dart';
import '../models/props.dart';
import '../render_payload.dart';
import 'icon.dart';

class VWCalendar extends VirtualLeafStatelessWidget {
  VWCalendar({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    DateTime firstDay =
        DateDecoder.toDate(props.get('firstDay')) ?? DateTime(1970, 1, 1);
    DateTime lastDay =
        DateDecoder.toDate(props.get('lastDay')) ?? DateTime(2100, 1, 1);
    DateTime? currentDay = DateDecoder.toDate(props.get('currentDay'));

    CalendarFormat calendarFormat =
        _toCalendarFormat(props.get('calendarFormat')) ?? CalendarFormat.month;
    bool headersVisible = props.getBool('headersVisible') ?? true;
    bool daysOfWeekVisible = props.getBool('daysOfWeekVisible') ?? true;
    double rowHeight = props.getDouble('rowHeight') ?? 52.0;
    double daysOfWeekHeight = props.getDouble('daysOfWeekHeight') ?? 16.0;
    StartingDayOfWeek startingDayOfWeek =
        _toStartingDayOfWeek(props.get('startingDayOfWeek')) ??
            StartingDayOfWeek.sunday;
    bool pageJumpingEnabled = props.getBool('pageJumpingEnabled') ?? false;
    bool shouldFillViewport = props.getBool('shouldFillViewport') ?? false;
    bool weekNumbersVisible = false;

    Props headerStyle = props.toProps('headerStyle') ?? Props.empty();
    Props daysOfWeekStyle = props.toProps('daysOfWeekStyle') ?? Props.empty();
    Props calendarStyle = props.toProps('calendarStyle') ?? Props.empty();

    RangeSelectionMode rangeSelectionMode = _toRangeSelectionMode(
            props.toProps('rangeSelectionMode') ?? Props.empty()) ??
        RangeSelectionMode.disabled;
    DateTime? selectedRangeStart;
    DateTime? selectedRangeEnd;
    DateTime? selectedDate;
    late DateTime focusedDay;

    if (rangeSelectionMode == RangeSelectionMode.enforced) {
      final selectedRange = ifNotNull2(
          DateDecoder.toDate(payload.eval<String>(
              props.get('rangeSelectionMode.rangeStartDateInitialValue'))),
          DateDecoder.toDate(payload.eval<String>(
              props.get('rangeSelectionMode.rangeEndDateInitialValue'))),
          (p0, p1) => (start: p0, end: p1));

      selectedRangeStart = selectedRange?.start;
      selectedRangeEnd = selectedRange?.end;

      focusedDay = selectedRangeStart ?? DateTime.now();
    }
    if (rangeSelectionMode == RangeSelectionMode.disabled) {
      selectedDate = ifNotNull(
          DateDecoder.toDate(payload
              .eval<String>(props.get('rangeSelectionMode.selectedDate'))),
          (p0) => p0);

      focusedDay = selectedDate ?? DateTime.now();
    }

    return InternalCalendar(
      focusedDay: focusedDay,
      firstDay: firstDay,
      lastDay: lastDay,
      currentDay: currentDay,
      rangeStartDay: selectedRangeStart,
      rangeEndDay: selectedRangeEnd,
      calendarFormat: calendarFormat,
      rangeSelectionMode: rangeSelectionMode,
      headersVisible: headersVisible,
      daysOfWeekVisible: daysOfWeekVisible,
      rowHeight: rowHeight,
      daysOfWeekHeight: daysOfWeekHeight,
      startingDayOfWeek: startingDayOfWeek,
      pageJumpingEnabled: pageJumpingEnabled,
      shouldFillViewport: shouldFillViewport,
      weekNumbersVisible: weekNumbersVisible,
      headerStyle: _toHeaderStyle(payload, headerStyle),
      daysOfWeekStyle: _toDaysOfWeekStyleFromJson(payload, daysOfWeekStyle),
      calendarStyle: _toCalendarStyleFromJson(payload, calendarStyle),
      selectedDate: selectedDate,
      selectedRangeStart: selectedRangeStart,
      selectedRangeEnd: selectedRangeEnd,
    );
  }

  // Header Props
  HeaderStyle _toHeaderStyle(RenderPayload payload, Props headerStyle) {
    if (headerStyle.isEmpty ||
        headerStyle.toProps('leftChevronIcon')?.get('iconData') == null) {
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

    bool titleCentered = headerStyle.getBool('titleCentered') ?? false;
    BoxShape? shape = _toBoxShape(headerStyle.get('shape'));
    TextStyle titleTextStyle = toTextStyle(
            DUITextStyle.fromJson(headerStyle.get('titleTextStyle')),
            payload.buildContext) ??
        const TextStyle(fontSize: 17.0);
    EdgeInsets? headerPadding =
        DUIDecoder.toEdgeInsets(headerStyle.get('headerPadding'));
    Widget? leftChevronIcon = VWIcon(
      props: headerStyle.toProps('leftChevronIcon') ?? Props.empty(),
      commonProps: null,
      parent: null,
    ).toWidget(payload);
    EdgeInsets? leftChevronPadding =
        DUIDecoder.toEdgeInsets(headerStyle.get('leftChevronPadding'));
    Widget? rightChevronIcon = VWIcon(
      props: headerStyle.toProps('rightChevronIcon') ?? Props.empty(),
      commonProps: null,
      parent: null,
    ).toWidget(payload);
    EdgeInsets? rightChevronPadding =
        DUIDecoder.toEdgeInsets(headerStyle.get('rightChevronPadding'));
    final shapeProps = headerStyle.toProps('shape');
    Color? headerColor = makeColor(shapeProps?.get('color'));
    Color headerBorderColor =
        makeColor(shapeProps?.get('borderColor')) ?? const Color(0xFF000000);
    double headerBorderWidth = shapeProps?.getDouble('borderWidth') ?? 1.0;
    BorderRadius? headerBorderRadius =
        DUIDecoder.toBorderRadius(shapeProps?.get('borderRadius'));

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
  DaysOfWeekStyle _toDaysOfWeekStyleFromJson(
      RenderPayload payload, Props daysOfWeekStyle) {
    if (daysOfWeekStyle.isEmpty) {
      return const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Color(0xFF4F4F4F)),
        weekendStyle: TextStyle(color: Color(0xFF6A6A6A)),
        decoration: BoxDecoration(),
      );
    }

    BoxShape? shape = _toBoxShape(daysOfWeekStyle.get('shape'));
    TextStyle weekdayStyle = toTextStyle(
            DUITextStyle.fromJson(daysOfWeekStyle.get('weekdayStyle')),
            payload.buildContext) ??
        const TextStyle(color: Color(0xFF4F4F4F));
    TextStyle weekendStyle = toTextStyle(
            DUITextStyle.fromJson(daysOfWeekStyle.get('weekendStyle')),
            payload.buildContext) ??
        const TextStyle(color: Color(0xFF6A6A6A));
    final shapeProps = daysOfWeekStyle.toProps('shape');
    Color? daysOfWeekColor = makeColor(shapeProps?.get('color'));
    Color daysOfWeekBorderColor =
        makeColor(shapeProps?.get('borderColor')) ?? const Color(0xFF000000);
    double daysOfWeekBorderWidth = shapeProps?.getDouble('borderWidth') ?? 1.0;
    BorderRadius? daysOfWeekBorderRadius =
        DUIDecoder.toBorderRadius(shapeProps?.get('borderRadius'));

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
  CalendarStyle _toCalendarStyleFromJson(
      RenderPayload payload, Props calendarStyle) {
    if (calendarStyle.isEmpty) {
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
        calendarStyle.getDouble('rangeHighlightScale');
    Color? rangeHighlightColor =
        makeColor(calendarStyle.get('rangeHighlightColor'));
    bool? outsideDaysVisible = calendarStyle.getBool('outsideDaysVisible');
    bool? isTodayHighlighted = calendarStyle.getBool('isTodayHighlighted');
    Color? tableBorderColor =
        makeColor(calendarStyle.get('tableBorderColor')) ?? Colors.black;
    double? tableBorderWidth = calendarStyle.getDouble('tableBorderWidth');
    BorderStyle? tableBorderStyle =
        _toBorderStyle(calendarStyle.get('tableBorderStyle'));
    BorderRadius? tableBorderRadius =
        DUIDecoder.toBorderRadius(calendarStyle.get('tableBorderRadius'));
    TableBorder? tableBorder = _toTableBorder(Props({
      'color': tableBorderColor,
      'width': tableBorderWidth,
      'style': tableBorderStyle,
      'borderRadius': tableBorderRadius,
    }));
    EdgeInsets? tablePadding =
        DUIDecoder.toEdgeInsets(calendarStyle.get('tablePadding'));

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
  CalendarFormat? _toCalendarFormat(Object? value) => switch (value) {
        'week' => CalendarFormat.week,
        'twoWeeks' => CalendarFormat.twoWeeks,
        'month' => CalendarFormat.month,
        _ => null
      };

  StartingDayOfWeek? _toStartingDayOfWeek(Object? value) => switch (value) {
        'monday' => StartingDayOfWeek.monday,
        'sunday' => StartingDayOfWeek.sunday,
        _ => null
      };

  RangeSelectionMode? _toRangeSelectionMode(Props mode) {
    if (mode.get('value') == 'singleDate') {
      return RangeSelectionMode.disabled;
    } else if (mode.get('value') == 'range') {
      return RangeSelectionMode.enforced;
    }

    return RangeSelectionMode.disabled;
  }

  BoxShape _toBoxShape(Object? value) => switch (value) {
        'circle' => BoxShape.circle,
        'rectangle' => BoxShape.rectangle,
        _ => BoxShape.rectangle
      };

  TableBorder? _toTableBorder(Props value) {
    if (value.isEmpty) return null;
    return TableBorder.all(
      color: makeColor(value.get('color')) ?? Colors.transparent,
      width: value.getDouble('width') ?? 1.0,
      style: _toBorderStyle(value.get('style')),
      borderRadius: DUIDecoder.toBorderRadius(value.get('borderRadius')),
    );
  }

  BorderStyle _toBorderStyle(Object? value) => switch (value) {
        'none' => BorderStyle.none,
        'solid' => BorderStyle.solid,
        _ => BorderStyle.solid
      };
}
