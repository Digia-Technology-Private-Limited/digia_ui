// import 'package:flutter/rendering.dart';

import 'package:flutter/widgets.dart';

import 'core/virtual_widget.dart';
import 'models/vw_node_data.dart';
import 'virtual_widget_registry.dart';
import 'widgets/animated_button.dart';
import 'widgets/async_builder.dart';
import 'widgets/avatar.dart';
import 'widgets/button.dart';
import 'widgets/calendar.dart';
import 'widgets/checkbox.dart';
import 'widgets/circular_progress_bar.dart';
import 'widgets/container.dart';
import 'widgets/expandable.dart';
// import 'widgets/flex.dart';
import 'widgets/flex.dart';
import 'widgets/flex_fit.dart';
import 'widgets/grid_view.dart';
import 'widgets/horizontal_divider.dart';
import 'widgets/html_view.dart';
import 'widgets/icon.dart';
import 'widgets/icon_button.dart';
import 'widgets/image.dart';
import 'widgets/linear_progress_bar.dart';
import 'widgets/list_view.dart';
import 'widgets/lottie.dart';
import 'widgets/opacity.dart';
import 'widgets/refresh_indicator.dart';
import 'widgets/rich_text.dart';
import 'widgets/safe_area.dart';
import 'widgets/sized_box.dart';
import 'widgets/spacer.dart';
// import 'widgets/stack.dart';
import 'widgets/stream_builder.dart';
import 'widgets/styled_horizontal_divider.dart';
import 'widgets/styled_vertical_divider.dart';
import 'widgets/switch.dart';
import 'widgets/text.dart';
import 'widgets/timer.dart';
import 'widgets/vertical_divider.dart';
import 'widgets/video_player.dart';
import 'widgets/web_view.dart';
import 'widgets/wrap.dart';
import 'widgets/youtube_player.dart';

Map<String, List<VirtualWidget>>? _createChildGroups(
    Map<String, List<VWNodeData>>? childGroups,
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

VWText textBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWText(
    props: data.props,
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

VWContainer containerBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWContainer(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    childGroups: _createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWIcon iconBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWIcon(
    props: data.props,
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
    childGroups: _createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWFlexFit flexFitBuilder(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
) {
  return VWFlexFit(
    props: data.props,
    parent: parent,
    refName: data.refName,
    childGroups: _createChildGroups(data.childGroups, parent, registry),
  );
}

VWListView listViewBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWListView(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    repeatData: data.repeatData,
    childGroups: _createChildGroups(data.childGroups, parent, registry),
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
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWSpacer spacerBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWSpacer(
    props: data.props,
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

// VWStack stackBuilder(
//     VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
//   return VWStack(
//     props: data.props,
//     commonProps: data.commonProps,
//     parent: parent,
//     repeatData: data.repeatData,
//     childGroups: _createChildGroups(data.childGroups, parent, registry),
//     refName: data.refName,
//   );
// }

VWVideoPlayer videoPlayerBuilder(VWNodeData data, VirtualWidget? parent, _) {
  return VWVideoPlayer(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWHorizontalDivider horizontalDividerBuilder(
    VWNodeData data, VirtualWidget? parent, _) {
  return VWHorizontalDivider(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWVerticalDivider verticalDividerBuilder(
    VWNodeData data, VirtualWidget? parent, _) {
  return VWVerticalDivider(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWStyledHorizontalDivider styledHorizontalDividerBuilder(
    VWNodeData data, VirtualWidget? parent, _) {
  return VWStyledHorizontalDivider(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

VWStyledVerticalDivider styledVerticalDividerBuilder(
    VWNodeData data, VirtualWidget? parent, _) {
  return VWStyledVerticalDivider(
    props: data.props,
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

VWSafeArea safeAreaBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWSafeArea(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    repeatData: data.repeatData,
    childGroups: _createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWGridView gridViewBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWGridView(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    repeatData: data.repeatData,
    childGroups: _createChildGroups(data.childGroups, parent, registry),
    refName: data.refName,
  );
}

VWAnimatedButton animatedButtonBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWAnimatedButton(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
  );
}

// VWFlex flexBuilder(VWNodeData data, VirtualWidget? parent,
//     VirtualWidgetRegistry registry, Axis direction) {
//   return VWFlex(
//     props: data.props,
//     commonProps: data.commonProps,
//     parent: parent,
//     repeatData: data.repeatData,
//     childGroups: _createChildGroups(data.childGroups, parent, registry),
//     refName: data.refName,
//     direction: direction,
//   );
// }

// VWFlex rowBuilder(
//     VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
//   return flexBuilder(data, parent, registry, Axis.horizontal);
// }

// VWFlex columnBuilder(
//     VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
//   return flexBuilder(data, parent, registry, Axis.vertical);
// }

VWExpandable expandableBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWExpandable(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: _createChildGroups(data.childGroups, parent, registry),
  );
}

VWWrap wrapBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWWrap(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: _createChildGroups(data.childGroups, parent, registry),
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
    props: data.props,
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
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWTimer(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: _createChildGroups(data.childGroups, parent, registry),
  );
}

VWAsyncBuilder asyncBuilderBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWAsyncBuilder(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: _createChildGroups(data.childGroups, parent, registry),
  );
}

VWStreamBuilder streamBuilderBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWStreamBuilder(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: _createChildGroups(data.childGroups, parent, registry),
  );
}

VWRefreshIndicator refreshIndicatorBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWRefreshIndicator(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: _createChildGroups(data.childGroups, parent, registry),
    repeatData: data.repeatData,
  );
}

VWOpacity opacityBuilder(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry) {
  return VWOpacity(
    props: data.props,
    commonProps: data.commonProps,
    parent: parent,
    refName: data.refName,
    childGroups: _createChildGroups(data.childGroups, parent, registry),
    repeatData: data.repeatData,
  );
}
