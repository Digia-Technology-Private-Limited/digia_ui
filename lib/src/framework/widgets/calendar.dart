import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../actions/base/action_flow.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../internal_widgets/internal_calendar.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/date_util.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../widget_props/icon_props.dart';
import 'icon.dart';

class VWCalendar extends VirtualLeafStatelessWidget<Props> {
  VWCalendar({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    DateTime firstDay =
        DateUtil.toDate(props.get('firstDay')) ?? DateTime(1970, 1, 1);
    DateTime lastDay =
        DateUtil.toDate(props.get('lastDay')) ?? DateTime(2100, 1, 1);
    DateTime? currentDay = DateUtil.toDate(props.get('currentDay'));

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
    bool weekNumbersVisible = props.getBool('weekNumbersVisible') ?? false;
    bool yearSelectorEnabled = props.getBool('yearSelectorEnabled') ?? false;

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
      final selectedRange = (
        DateUtil.toDate(payload.eval<String>(
            props.get('rangeSelectionMode.rangeStartDateInitialValue'))),
        DateUtil.toDate(payload.eval<String>(
            props.get('rangeSelectionMode.rangeEndDateInitialValue')))
      ).maybe((p0, p1) => (start: p0, end: p1));

      selectedRangeStart = selectedRange?.start;
      selectedRangeEnd = selectedRange?.end;

      focusedDay = selectedRangeStart ?? DateTime.now();
    }
    if (rangeSelectionMode == RangeSelectionMode.disabled) {
      selectedDate = DateUtil.toDate(
          payload.eval<String>(props.get('rangeSelectionMode.selectedDate')));

      focusedDay = selectedDate ?? DateTime.now();
    }

    final ActionFlow? onDateSelected =
        ActionFlow.fromJson(props.get('rangeSelectionMode.onDateSelected'));
    final ActionFlow? onRangeSelected =
        ActionFlow.fromJson(props.get('rangeSelectionMode.onRangeSelected'));

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
      yearSelectorEnabled: yearSelectorEnabled,
      headerStyle: _toHeaderStyle(payload, headerStyle),
      daysOfWeekStyle: _toDaysOfWeekStyleFromJson(payload, daysOfWeekStyle),
      calendarStyle: _toCalendarStyleFromJson(payload, calendarStyle),
      selectedDate: selectedDate,
      selectedRangeStart: selectedRangeStart,
      selectedRangeEnd: selectedRangeEnd,
      onDateSelected: (selectedDay, focusedDay) async {
        await payload.executeAction(
          onDateSelected,
          scopeContext: DefaultScopeContext(variables: {
            'selectedDate': selectedDay.toIso8601String(),
            'focusedDay': focusedDay.toIso8601String(),
          }),
          triggerType: 'onDateSelected',
        );
      },
      onRangeSelected:
          (selectedRangeStart, selectedRangeEnd, focusedDay) async {
        await payload.executeAction(
          onRangeSelected,
          scopeContext: DefaultScopeContext(variables: {
            'selectedRangeStart': selectedRangeStart?.toIso8601String(),
            'selectedRangeEnd': selectedRangeEnd?.toIso8601String(),
            'focusedDay': focusedDay.toIso8601String(),
          }),
          triggerType: 'onRangeSelected',
        );
      },
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
    TextStyle titleTextStyle =
        payload.getTextStyle(headerStyle.getMap('titleTextStyle')) ??
            const TextStyle(fontSize: 17.0);
    EdgeInsets? headerPadding = To.edgeInsets(headerStyle.get('headerPadding'));
    Widget? leftChevronIcon = VWIcon(
      props: IconProps.fromJson(headerStyle.getMap('leftChevronIcon')) ??
          IconProps.empty(),
      commonProps: null,
      parent: null,
    ).toWidget(payload);
    EdgeInsets? leftChevronPadding =
        To.edgeInsets(headerStyle.get('leftChevronPadding'));
    Widget? rightChevronIcon = VWIcon(
      props: IconProps.fromJson(headerStyle.getMap('rightChevronIcon')) ??
          IconProps.empty(),
      commonProps: null,
      parent: null,
    ).toWidget(payload);
    EdgeInsets? rightChevronPadding =
        To.edgeInsets(headerStyle.get('rightChevronPadding'));
    final shapeProps = headerStyle.toProps('shape');
    Color? headerColor = shapeProps?.getString('color').maybe(payload.getColor);
    Color headerBorderColor =
        shapeProps?.getString('borderColor').maybe(payload.getColor) ??
            const Color(0xFF000000);
    double headerBorderWidth = shapeProps?.getDouble('borderWidth') ?? 1.0;
    BorderRadius? headerBorderRadius =
        To.borderRadius(shapeProps?.get('borderRadius'));

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
    TextStyle weekdayStyle =
        payload.getTextStyle(daysOfWeekStyle.getMap('weekdayStyle')) ??
            const TextStyle(color: Color(0xFF4F4F4F));
    TextStyle weekendStyle =
        payload.getTextStyle(daysOfWeekStyle.getMap('weekendStyle')) ??
            const TextStyle(color: Color(0xFF6A6A6A));
    final shapeProps = daysOfWeekStyle.toProps('shape');
    Color? daysOfWeekColor =
        shapeProps?.getString('color').maybe(payload.getColor);
    Color daysOfWeekBorderColor =
        shapeProps?.getString('borderColor').maybe(payload.getColor) ??
            const Color(0xFF000000);
    double daysOfWeekBorderWidth = shapeProps?.getDouble('borderWidth') ?? 1.0;
    BorderRadius? daysOfWeekBorderRadius =
        To.borderRadius(shapeProps?.get('borderRadius'));

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
        calendarStyle.getString('rangeHighlightColor').maybe(payload.getColor);
    bool? outsideDaysVisible = calendarStyle.getBool('outsideDaysVisible');
    bool? isTodayHighlighted = calendarStyle.getBool('isTodayHighlighted');
    TableBorder? tableBorder = _toTableBorder(
        payload,
        Props({
          'color': calendarStyle.getString('tableBorderColor'),
          'width': calendarStyle.getDouble('tableBorderWidth'),
          'style': calendarStyle.get('tableBorderStyle'),
          'borderRadius': calendarStyle.get('tableBorderRadius'),
        }));
    EdgeInsets? tablePadding = To.edgeInsets(calendarStyle.get('tablePadding'));

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

  TableBorder? _toTableBorder(RenderPayload payload, Props value) {
    if (value.isEmpty) return null;
    return TableBorder.all(
      color: value.getString('color').maybe(payload.getColor) ??
          Colors.transparent,
      width: value.getDouble('width') ?? 1.0,
      style: _toBorderStyle(value.get('style')),
      borderRadius: To.borderRadius(value.get('borderRadius')),
    );
  }

  BorderStyle _toBorderStyle(Object? value) => switch (value) {
        'none' => BorderStyle.none,
        'solid' => BorderStyle.solid,
        _ => BorderStyle.solid
      };
}
