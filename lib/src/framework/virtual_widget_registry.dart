import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import 'base/virtual_builder_widget.dart';
import 'base/virtual_widget.dart';
import 'builders.dart';
import 'models/vw_data.dart';
import 'utils/types.dart';

typedef VirtualWidgetBuilder = VirtualWidget Function(
  VWNodeData data,
  VirtualWidget? parent,
  VirtualWidgetRegistry registry,
);

typedef ComponentBuilder = Widget Function(
  String id,
  JsonLike? args,
  ObservabilityContext? observabilityContext,
);

abstract class VirtualWidgetRegistry {
  static final Map<String, VirtualWidgetBuilder> _defaultBuilders = {
    // Layout Widgets
    'digia/container': containerBuilder,
    'digia/column': columnBuilder,
    'digia/row': rowBuilder,
    'digia/stack': stackBuilder,
    'digia/listView': listViewBuilder,
    'digia/gridView': gridViewBuilder,
    'digia/wrap': wrapBuilder,
    'fw/sized_box': sizedBoxBuilder,
    'fw/spacer': spacerBuilder,
    'digia/safeArea': safeAreaBuilder,
    'digia/smartScrollView': smartScrollViewBuilder,
    'digia/nestedScrollView': nestedScrollViewBuilder,

    // Basic Widgets
    'digia/text': textBuilder,
    'digia/markdown': markdownBuilder,
    'digia/richText': richTextBuilder,
    'digia/icon': iconBuilder,
    'digia/image': imageBuilder,
    'digia/button': buttonBuilder,
    'digia/iconButton': iconButtonBuilder,
    'digia/checkbox': checkboxBuilder,
    'digia/switch': switchBuilder,
    'digia/textFormField': textFormFieldBuilder,

    // Navigation and Structure
    'digia/scaffold': scaffoldBuilder,
    'fw/scaffold': scaffoldBuilder,
    'fw/appBar': appBarBuilder,
    'digia/appBar': appBarBuilder,
    'digia/sliverAppBar': sliverAppBarBuilder,
    'digia/sliverList': sliverListBuilder,
    'digia/sliverGrid': sliverGridBuilder,
    'digia/drawer': drawerBuilder,
    'digia/tabController': tabControllerBuilder,
    'digia/tabBar': tabBarBuilder,
    'digia/tabViewContent': tabViewContentBuilder,
    'digia/navigationBar': navigationBarBuilder,
    'digia/navigationBarItem': navigationBarItemBuilder,
    'digia/navigationBarCustom': navigationBarCustomBuilder,
    'digia/navigationBarItemCustom': navigationBarItemCustomBuilder,
    'digia/overlay': overlayBuilder,
    'digia/pageView': pageViewBuilder,
    'digia/smartScrollGroup': smartScrollGroupBuilder,
    'digia/pinnedHeader': pinnedHeaderBuilder,
    // 'digia/tabView': tabViewBuilder,
    // 'digia/tabViewItem': tabViewItemBuilder,

    // Dividers and Decorative Elements
    'digia/horizontalDivider': horizontalDividerBuilder,
    'digia/verticalDivider': verticalDividerBuilder,
    'digia/styledHorizontalDivider': styledHorizontalDividerBuilder,
    'digia/styledVerticalDivider': styledVerticalDividerBuilder,
    'digia/avatar': avatarBuilder,

    // Interactive Widgets
    'digia/animatedButton': animatedButtonBuilder,
    'digia/expandable': expandableBuilder,
    'digia/refreshIndicator': refreshIndicatorBuilder,
    'digia/beforeAfterSlider': beforeAfterSliderBuilder,
    'digia/imageView360': imageView360Builder,
    // 'digia/stepper': stepperBuilder,
    // 'digia/flutterStepper': flutterStepperBuilder,
    'digia/pinField': pinFieldBuilder,
    'digia/calendar': calendarBuilder,
    'digia/rangeSlider': rangeSliderBuilder,

    // Media and Web Content
    'digia/lottie': lottieBuilder,
    'digia/youtubePlayer': youtubePlayerBuilder,
    'digia/videoPlayer': videoPlayerBuilder,
    'digia/storyVideoPlayer': storyVideoPlayerBuilder,
    'digia/htmlView': htmlViewBuilder,
    'digia/webView': webViewBuilder,

    // Data Display
    'digia/carousel': carouselBuilder,
    'digia/circularProgressBar': circularProgressBarBuilder,
    'digia/linearProgressBar': linearProgressBarBuilder,
    'digia/paginatedListView': paginatedListViewBuilder,
    'digia/paginatedSliverList': paginatedSliverListBuilder,

    // Async Widgets
    'digia/futureBuilder': asyncBuilderBuilder,
    'digia/asyncBuilder': asyncBuilderBuilder,
    'digia/streamBuilder': streamBuilderBuilder,

    // Utility Widgets
    'digia/conditionalBuilder': conditionalBuilderBuilder,
    'digia/conditionalItem': conditionalItemBuilder,
    'digia/opacity': opacityBuilder,
    'digia/animationBuilder': animationBuilder,
    'digia/animatedSwitcher': animatedSwitcher,
    'digia/timer': timerBuilder,
    'digia/story': storyBuilder,
  };

  void registerWidget<T>(
    String type,
    T Function(JsonLike) fromJsonT,
    VirtualWidget Function(
      T props,
      Map<String, List<VirtualWidget>>? childGroups,
    ) builder,
  );

  void registerJsonWidget(
    String type,
    VirtualWidget Function(
      JsonLike props,
      Map<String, List<VirtualWidget>>? childGroups,
    ) builder,
  );

  factory VirtualWidgetRegistry({
    required ComponentBuilder componentBuilder,
  }) = DefaultVirtualWidgetRegistry;

  VirtualWidget createWidget(VWData data, VirtualWidget? parent);

  void dispose();
}

class DefaultVirtualWidgetRegistry implements VirtualWidgetRegistry {
  final ComponentBuilder componentBuilder;

  final Map<String, VirtualWidgetBuilder> builders;

  DefaultVirtualWidgetRegistry({
    required this.componentBuilder,
  }) : builders = Map.from(VirtualWidgetRegistry._defaultBuilders);

  @override
  VirtualWidget createWidget(VWData data, VirtualWidget? parent) {
    VirtualWidget widget;

    switch (data) {
      case VWNodeData():
        {
          String type = data.type;
          if (!builders.containsKey(type)) {
            throw Exception('Unknown widget type: $type');
          }
          widget = builders[type]!(data, parent, this);
        }
        break;
      case VWStateData():
        widget = stateContainerBuilder(data, parent, this);
        break;
      case VWComponentData():
        widget = VirtualBuilderWidget(
          commonProps: data.commonProps,
          parentProps: data.parentProps,
          parent: parent,
          refName: data.refName,
          extendHierarchy: false,
          (payload) => componentBuilder(
            data.id,
            data.args?.map(
              (k, v) => MapEntry(
                k,
                v?.evaluate(payload.scopeContext),
              ),
            ),
            payload.observabilityContext,
          ),
        );

        break;
    }

    return widget;
  }

  @override
  void registerWidget<T>(
      String type,
      T Function(JsonLike) fromJsonT,
      VirtualWidget Function(
        T props,
        Map<String, List<VirtualWidget>>? childGroups,
      ) builder) {
    builders[type] = (data, parent, registry) {
      return builder(
        fromJsonT(data.props.value),
        createChildGroups(data.childGroups, parent, registry),
      );
    };
  }

  @override
  void registerJsonWidget(
    String type,
    VirtualWidget Function(
      JsonLike props,
      Map<String, List<VirtualWidget>>? childGroups,
    ) builder,
  ) {
    builders[type] = (data, parent, registry) {
      return builder(
        data.props.value,
        createChildGroups(data.childGroups, parent, registry),
      );
    };
  }

  @override
  void dispose() {
    builders.clear();
  }
}
