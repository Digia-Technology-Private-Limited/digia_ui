import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../Utils/basic_shared_utils/date_decoder.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_calendar.dart';
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
    DateTime currentDay =
        DateDecoder.toDate(props.get('currentDay')) ?? DateTime.now();

    CalendarFormat calendarFormat =
        _toCalendarFormat(props.get('calendarFormat')) ?? CalendarFormat.month;
    bool headersVisible =
        NumDecoder.toBool(props.get('headersVisible')) ?? true;
    bool daysOfWeekVisible =
        NumDecoder.toBool(props.get('daysOfWeekVisible')) ?? true;
    double rowHeight = NumDecoder.toDouble(props.get('rowHeight')) ?? 52.0;
    double daysOfWeekHeight =
        NumDecoder.toDouble(props.get('daysOfWeekHeight')) ?? 16.0;
    StartingDayOfWeek startingDayOfWeek =
        _toStartingDayOfWeek(props.get('startingDayOfWeek')) ??
            StartingDayOfWeek.sunday;
    bool pageJumpingEnabled =
        NumDecoder.toBool(props.get('pageJumpingEnabled')) ?? false;
    bool shouldFillViewport =
        NumDecoder.toBool(props.get('shouldFillViewport')) ?? false;
    bool weekNumbersVisible = false;

    Map<String, Object?>? headerStyle = props.getMap('headerStyle');
    Map<String, Object?>? daysOfWeekStyle = props.getMap('daysOfWeekStyle');
    Map<String, Object?>? calendarStyle = props.getMap('calendarStyle');

    RangeSelectionMode rangeSelectionMode =
        _toRangeSelectionMode(props.get('rangeSelectionMode')) ??
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
  HeaderStyle _toHeaderStyle(
      RenderPayload payload, Map<String, dynamic>? headerStyle) {
    if (headerStyle == null ||
        headerStyle['leftChevronIcon']['iconData'] == null) {
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
        NumDecoder.toBool(headerStyle['titleCentered']) ?? false;
    BoxShape? shape = _toBoxShape(headerStyle['shape']);
    TextStyle titleTextStyle = toTextStyle(
            DUITextStyle.fromJson(headerStyle['titleTextStyle']),
            payload.buildContext) ??
        const TextStyle(fontSize: 17.0);
    EdgeInsets? headerPadding =
        DUIDecoder.toEdgeInsets(headerStyle['headerPadding']);
    Widget? leftChevronIcon = VWIcon(
      props: headerStyle['leftChevronIcon'],
      commonProps: null,
      parent: null,
    ).toWidget(payload);
    EdgeInsets? leftChevronPadding =
        DUIDecoder.toEdgeInsets(headerStyle['leftChevronPadding']);
    Widget? rightChevronIcon = VWIcon(
      props: headerStyle['rightChevronIcon'],
      commonProps: null,
      parent: null,
    ).toWidget(payload);
    EdgeInsets? rightChevronPadding =
        DUIDecoder.toEdgeInsets(headerStyle['rightChevronPadding']);
    Color? headerColor = makeColor(headerStyle['shape']['color']);
    Color headerBorderColor = makeColor(headerStyle['shape']['borderColor']) ??
        const Color(0xFF000000);
    double headerBorderWidth =
        NumDecoder.toDouble(headerStyle['shape']['borderWidth']) ?? 1.0;
    BorderRadius? headerBorderRadius =
        DUIDecoder.toBorderRadius(headerStyle['shape']['borderRadius']);

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
      RenderPayload payload, Map<String, dynamic>? daysOfWeekStyle) {
    if (daysOfWeekStyle == null) {
      return const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Color(0xFF4F4F4F)),
        weekendStyle: TextStyle(color: Color(0xFF6A6A6A)),
        decoration: BoxDecoration(),
      );
    }

    BoxShape? shape = _toBoxShape(daysOfWeekStyle['shape']);
    TextStyle weekdayStyle = toTextStyle(
            DUITextStyle.fromJson(daysOfWeekStyle['weekdayStyle']),
            payload.buildContext) ??
        const TextStyle(color: Color(0xFF4F4F4F));
    TextStyle weekendStyle = toTextStyle(
            DUITextStyle.fromJson(daysOfWeekStyle['weekendStyle']),
            payload.buildContext) ??
        const TextStyle(color: Color(0xFF6A6A6A));
    Color? daysOfWeekColor = makeColor(daysOfWeekStyle['shape']['color']);
    Color daysOfWeekBorderColor =
        makeColor(daysOfWeekStyle['shape']['borderColor']) ??
            const Color(0xFF000000);
    double daysOfWeekBorderWidth =
        NumDecoder.toDouble(daysOfWeekStyle['shape']['borderWidth']) ?? 1.0;
    BorderRadius? daysOfWeekBorderRadius =
        DUIDecoder.toBorderRadius(daysOfWeekStyle['shape']['borderRadius']);

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
      RenderPayload payload, Map<String, dynamic>? calendarStyle) {
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
        NumDecoder.toDouble(calendarStyle['rangeHighlightScale']);
    Color? rangeHighlightColor =
        makeColor(calendarStyle['rangeHighlightColor']);
    bool? outsideDaysVisible =
        NumDecoder.toBool(calendarStyle['outsideDaysVisible']);
    bool? isTodayHighlighted =
        NumDecoder.toBool(calendarStyle['isTodayHighlighted']);
    Color? tableBorderColor =
        makeColor(calendarStyle['tableBorderColor']) ?? Colors.black;
    double? tableBorderWidth =
        NumDecoder.toDouble(calendarStyle['tableBorderWidth']);
    BorderStyle? tableBorderStyle =
        _toBorderStyle(calendarStyle['tableBorderStyle']);
    BorderRadius? tableBorderRadius =
        DUIDecoder.toBorderRadius(calendarStyle['tableBorderRadius']);
    TableBorder? tableBorder = _toTableBorder({
      'color': tableBorderColor,
      'width': tableBorderWidth,
      'style': tableBorderStyle,
      'borderRadius': tableBorderRadius,
    });
    EdgeInsets? tablePadding =
        DUIDecoder.toEdgeInsets(calendarStyle['tablePadding']);

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

  RangeSelectionMode? _toRangeSelectionMode(dynamic mode) {
    if (mode['value'] == 'singleDate') {
      return RangeSelectionMode.disabled;
    } else if (mode['value'] == 'range') {
      return RangeSelectionMode.enforced;
    }

    return RangeSelectionMode.disabled;
  }

  BoxShape _toBoxShape(Object? value) => switch (value) {
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

  BorderStyle _toBorderStyle(Object? value) => switch (value) {
        'none' => BorderStyle.none,
        'solid' => BorderStyle.solid,
        _ => BorderStyle.solid
      };
}
