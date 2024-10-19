import 'package:flutter/painting.dart';

import 'base/virtual_widget.dart';
import 'models/types.dart';
import 'models/vw_data.dart';
import 'state/virtual_state_container_widget.dart';
import 'virtual_widget_registry.dart';
import 'widget_props/animated_switcher_props.dart';
import 'widget_props/app_bar_props.dart';
import 'widget_props/condtional_item_props.dart';
import 'widget_props/custom_scroll_view_props.dart';
import 'widget_props/flex_fit_props.dart';
import 'widget_props/icon_props.dart';
import 'widget_props/nested_scroll_view_props.dart';
import 'widget_props/opacity_props.dart';
import 'widget_props/paginated_list_view_props.dart';
import 'widget_props/paginated_sliver_list_props.dart';
import 'widget_props/pin_field_props.dart';
import 'widget_props/safe_area_props.dart';
import 'widget_props/sized_box_props.dart';
import 'widget_props/sliver_app_bar_props.dart';
import 'widget_props/spacer_props.dart';
import 'widget_props/stream_builder_props.dart';
import 'widget_props/styled_divider_props.dart';
import 'widget_props/switch_props.dart';
import 'widget_props/tab_view_content_props.dart';
import 'widget_props/tab_view_controller_props.dart';
import 'widget_props/text_props.dart';
import 'widget_props/timer_props.dart';
import 'widgets/animated_builder.dart';
import 'widgets/animated_button.dart';
import 'widgets/animated_switcher.dart';
import 'widgets/app_bar.dart';
import 'widgets/async_builder.dart';
import 'widgets/avatar.dart';
import 'widgets/button.dart';
import 'widgets/calendar.dart';
import 'widgets/checkbox.dart';
import 'widgets/circular_progress_bar.dart';
import 'widgets/conditional_builder.dart';
import 'widgets/condtional_item.dart';
import 'widgets/container.dart';
import 'widgets/custom_scroll_view.dart';
import 'widgets/drawer.dart';
import 'widgets/expandable.dart';
import 'widgets/flex.dart';
import 'widgets/flex_fit.dart';
import 'widgets/grid_view.dart';
import 'widgets/html_view.dart';
import 'widgets/icon.dart';
import 'widgets/icon_button.dart';
import 'widgets/image.dart';
import 'widgets/line_chart.dart';
import 'widgets/linear_progress_bar.dart';
import 'widgets/list_view.dart';
import 'widgets/lottie.dart';
import 'widgets/nested_scroll_view.dart';
import 'widgets/opacity.dart';
import 'widgets/paginated_list_view.dart';
import 'widgets/paginated_sliver_list.dart';
import 'widgets/pin_field.dart';
import 'widgets/refresh_indicator.dart';
import 'widgets/rich_text.dart';
import 'widgets/safe_area.dart';
import 'widgets/scaffold.dart';
import 'widgets/sized_box.dart';
import 'widgets/sliver_app_bar.dart';
import 'widgets/sliver_list.dart';
import 'widgets/spacer.dart';
import 'widgets/stack.dart';
import 'widgets/stream_builder.dart';
import 'widgets/styled_horizontal_divider.dart';
import 'widgets/styled_vertical_divider.dart';
import 'widgets/switch.dart';
import 'widgets/tab_view/tab_bar.dart';
import 'widgets/tab_view/tab_view_content.dart';
import 'widgets/tab_view/tab_view_controller.dart';
import 'widgets/text.dart';
import 'widgets/text_form_field.dart';
import 'widgets/timer.dart';
import 'widgets/video_player.dart';
import 'widgets/web_view.dart';
import 'widgets/wrap.dart';
import 'widgets/youtube_player.dart';

Map<String, List<VirtualWidget>>? createChildGroups(
    Map<String, List<VWData>>? childGroups,
    VirtualWidget? parent,
    VirtualWidgetRegistry registry) {
  if (childGroups == null || childGroups.isEmpty) return null;

  return childGroups.map((key, childrenData) {
    return MapEntry(
      key,
      childrenData.map((data) => registry.createWidget(data, parent)).toList(),
    );
  });
}

VirtualStateContainerWidget stateContainerBuilder(
  VWStateData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VirtualStateContainerWidget(
    refName: data.refName,
    parent: parent,
    initStateDefs: data.initStateDefs,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWText textBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWText(
    props: TextProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWRichText richTextBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWRichText(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWTextFormField textFormFieldBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWTextFormField(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWContainer containerBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWContainer(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWIcon iconBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWIcon(
    props: IconProps.fromJson(data.props.value) ?? IconProps.empty(),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWPinField pinFieldBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWPinField(
    props: PinFieldProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWFlex columnBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) =>
    flexBuilder(Axis.vertical, data, parent, registry);

VWFlex rowBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) =>
    flexBuilder(Axis.horizontal, data, parent, registry);

VWFlex flexBuilder(
  Axis direction,
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWFlex(
    direction: direction,
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    repeatData: data.repeatData,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWFlexFit flexFitBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWFlexFit(
    props: FlexFitProps.fromJson(data.props.value),
    parent: parent,
    refName: data.refName,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWListView listViewBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWListView(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    repeatData: data.repeatData,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWHtmlView htmlViewBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWHtmlView(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWAvatar avatarBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWAvatar(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWButton buttonBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWButton(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWIconButton iconButtonBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWIconButton(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWImage imageBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWImage(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWWebView webViewBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWWebView(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWSizedBox sizedBoxBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWSizedBox(
    props: SizedBoxProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWSpacer spacerBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWSpacer(
    props: SpacerProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWLottie lottieBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWLottie(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWStack stackBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWStack(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWVideoPlayer videoPlayerBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWVideoPlayer(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWStyledHorizontalDivider horizontalDividerBuilder(
    VWNodeData data, VirtualWidget? parent, _) {
  final props = data.props;
  return VWStyledHorizontalDivider(
    props: StyledDividerProps(
      thickness: props.get('thickness') != null
          ? ExprOr<double>(props.get('thickness')!)
          : null,
      lineStyle: data.props.getString('lineStyle'),
      size: SizeProps(
          height: props.get('height') != null
              ? ExprOr<double>(data.props.get('height')!)
              : null),
      indent: props.get('indent') != null
          ? ExprOr<double>(props.get('indent')!)
          : null,
      endIndent: props.get('endIndent') != null
          ? ExprOr<double>(props.get('endIndent')!)
          : null,
      color: props.get('color') != null
          ? ExprOr<String>(props.get('color')!)
          : null,
    ),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWStyledVerticalDivider verticalDividerBuilder(
    VWNodeData data, VirtualWidget? parent, _) {
  final props = data.props;
  return VWStyledVerticalDivider(
    props: StyledDividerProps(
      thickness: props.get('thickness') != null
          ? ExprOr<double>(props.get('thickness')!)
          : null,
      lineStyle: data.props.getString('lineStyle'),
      size: SizeProps(
          width: props.get('width') != null
              ? ExprOr<double>(data.props.get('width')!)
              : null),
      indent: props.get('indent') != null
          ? ExprOr<double>(props.get('indent')!)
          : null,
      endIndent: props.get('endIndent') != null
          ? ExprOr<double>(props.get('endIndent')!)
          : null,
      color: props.get('color') != null
          ? ExprOr<String>(props.get('color')!)
          : null,
    ),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWStyledHorizontalDivider styledHorizontalDividerBuilder(
    VWNodeData data, VirtualWidget? parent, _) {
  return VWStyledHorizontalDivider(
    props: StyledDividerProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWStyledVerticalDivider styledVerticalDividerBuilder(
    VWNodeData data, VirtualWidget? parent, _) {
  return VWStyledVerticalDivider(
    props: StyledDividerProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWCircularProgressBar circularProgressBarBuilder(
    VWNodeData data, VirtualWidget? parent, _) {
  return VWCircularProgressBar(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWLinearProgressBar linearProgressBarBuilder(
    VWNodeData data, VirtualWidget? parent, _) {
  return VWLinearProgressBar(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWCheckbox checkboxBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWCheckbox(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWAppBar appBarBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWAppBar(
    props: AppBarProps.fromJson(data.props.value),
    parent: parent,
  );
}

VWDrawer drawerBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWDrawer(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWScaffold scaffoldBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWScaffold(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWSafeArea safeAreaBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWSafeArea(
    props: SafeAreaProps.fromJson(data.props.value),
    childGroups: createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWGridView gridViewBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWGridView(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    repeatData: data.repeatData,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWAnimatedButton animatedButtonBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWAnimatedButton(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWExpandable expandableBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWExpandable(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWWrap wrapBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWWrap(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    repeatData: data.repeatData,
  );
}

VWYoutubePlayer youtubePlayerBuilder(
    VWNodeData data, VirtualWidget? parent, _) {
  return VWYoutubePlayer(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWSwitch switchBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWSwitch(
    props: SwitchProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWCalendar calendarBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWCalendar(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWTimer timerBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWTimer(
    props: TimerProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWAsyncBuilder asyncBuilderBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWAsyncBuilder(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWStreamBuilder streamBuilderBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWStreamBuilder(
    props: StreamBuilderProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWConditionalBuilder conditionalBuilderBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWConditionalBuilder(
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWConditionItem conditionalItemBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWConditionItem(
    props: CondtionalItemProps.fromJson(data.props.value),
    refName: data.refName,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWRefreshIndicator refreshIndicatorBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWRefreshIndicator(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    repeatData: data.repeatData,
  );
}

VWOpacity opacityBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWOpacity(
    props: OpacityProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    repeatData: data.repeatData,
  );
}

VWTabViewController tabControllerBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWTabViewController(
    props: TabViewControllerProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWTabBar tabBarBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWTabBar(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWTabViewContent tabViewContentBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWTabViewContent(
    props: TabViewContentProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    // repeatData: data.repeatData,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWPaginatedListView paginatedListViewBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWPaginatedListView(
    props: PaginatedListViewProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    repeatData: data.repeatData,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWPaginatedSliverList paginatedSliverListBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWPaginatedSliverList(
    props: PaginatedSliverListProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    repeatData: data.repeatData,
    childGroups: createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWSliverAppBar sliverAppBarBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWSliverAppBar(
    props: SliverAppBarProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    repeatData: data.repeatData,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWCustomScrollView customScrollViewBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWCustomScrollView(
    props: CustomScrollViewProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    repeatData: data.repeatData,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWNestedScrollView nestedScrollViewBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWNestedScrollView(
    props: NestedScrollViewProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    repeatData: data.repeatData,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWSliverList sliverListBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWSliverList(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    repeatData: data.repeatData,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWAnimatedBuilder animationBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWAnimatedBuilder(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWAnimatedSwitcher animatedSwitcher(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWAnimatedSwitcher(
    props: AnimatedSwitcherProps.fromJson(data.props.value),
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: createChildGroups(data.childGroups, parent, registry),
  );
}

VWLineChart lineChartBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWLineChart(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}
