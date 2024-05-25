import 'package:flutter/material.dart';
import '../core/builders/bottom_navigation_bar_item_builder.dart';
import '../core/builders/dezerv_stepper_builder.dart';
import '../core/builders/dezerv_component/dezerv_dial_pad_builder.dart';
import '../core/builders/dui_app_bar_builder.dart';
import '../core/builders/dui_avatar_builder.dart';
import '../core/builders/dui_button_builder.dart';
import '../core/builders/dui_carousel_builder.dart';
import '../core/builders/dui_circular_progress_indicator_builder.dart';
import '../core/builders/dui_container2_builder.dart';
import '../core/builders/dui_custom_widget_builder.dart';
import '../core/builders/dui_expandable_builder.dart';
import '../core/builders/dui_flex_builder.dart';
import '../core/builders/dui_future_builder.dart';
import '../core/builders/dui_gridview_builder.dart';
import '../core/builders/dui_horizontal_divider_builder.dart';
import '../core/builders/dui_htmlview_builder.dart';
import '../core/builders/dui_icon_builder.dart';
import '../core/builders/dui_icon_button_builder.dart';
import '../core/builders/dui_image_builder.dart';
import '../core/builders/dui_listview_builder.dart';
import '../core/builders/dui_lottie_builder.dart';
import '../core/builders/dui_rich_text_builder.dart';
import '../core/builders/dui_scaffold_builder.dart';
import '../core/builders/dui_sized_box_builder.dart';
import '../core/builders/dui_spacer_builder.dart';
import '../core/builders/dui_stack_builder.dart';
import '../core/builders/dui_tab_view_builder.dart';
import '../core/builders/dui_tab_view_item_builder.dart';
import '../core/builders/dui_text_builder.dart';
import '../core/builders/dui_text_field_builder.dart';
import '../core/builders/dui_vertical_divider_builder.dart';
import '../core/builders/dui_video_player_builder.dart';
import '../core/builders/dui_webview_builder.dart';
import '../core/builders/dui_wrap_builder.dart';
import '../core/builders/dui_youtube_player_builder.dart';
import '../core/json_widget_builder.dart';
import '../core/page/props/dui_widget_json_data.dart';

typedef WidgetFromJsonFn<T extends Widget> = T Function(
    Map<String, dynamic> json);

typedef DUIWidgetBuilderCreatorFn = DUIWidgetBuilder?
    Function(DUIWidgetJsonData data, {DUIWidgetRegistry? registry});

typedef DUIWidgetBuilderWithoutRegistryCreatorFn = DUIWidgetBuilder? Function(
    DUIWidgetJsonData data);

DUIWidgetBuilderCreatorFn withoutRegistry(
        DUIWidgetBuilderWithoutRegistryCreatorFn fn) =>
    (data, {registry}) {
      return fn(data);
    };

class DUIWidgetRegistry {
  const DUIWidgetRegistry();

  static final Map<String, DUIWidgetBuilderCreatorFn> builders = {
    'digia/icon': withoutRegistry(DUIIconBuilder.create),
    'digia/htmlView': withoutRegistry(DUIHtmlViewBuilder.create),
    'digia/avatar': withoutRegistry(DUIAvatarBuilder.create),
    'digia/richText': withoutRegistry(DUIRichTextBuilder.create),
    'digia/text': withoutRegistry(DUITextBuilder.create),
    'digia/button': withoutRegistry(DUIButtonBuilder.create),
    'digia/iconButton': withoutRegistry(DUIIconButtonBuilder.create),
    'digia/image': withoutRegistry(DUIImageBuilder.create),
    'digia/webView': withoutRegistry(DUIWebViewBuilder.create),
    'digia/listView': (data, {registry}) =>
        DUIListViewBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/gridView': (data, {registry}) =>
        DUIGridViewBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/carousel': (data, {registry}) =>
        DUICarouselBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/column': (data, {registry}) => DUIFlexBuilder.create(data,
        registry: DUIWidgetRegistry.shared, direction: Axis.vertical),
    'digia/row': (data, {registry}) => DUIFlexBuilder.create(data,
        registry: DUIWidgetRegistry.shared, direction: Axis.horizontal),
    // 'digia/expansionTile': (data, {registry}) =>
    //     DUIExpansionBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/expandable': (data, {registry}) =>
        DUIExpandableBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/wrap': (data, {registry}) => DUIWrapBuilder.create(data),
    'digia/container': withoutRegistry(DUIContainer2Builder.create),
    'fw/sized_box': withoutRegistry(DUISizedBoxBuilder.create),
    'fw/spacer': withoutRegistry(DUISpacerBuilder.create),
    'fw/appBar': withoutRegistry(DUIAppBarBuilder.create),
    'fw/scaffold': withoutRegistry(DUIScaffoldBuilder.create),
    'digia/lottie': (data, {registry}) => DUILottieBuilder.create(data),
    'digia/youtubePlayer': (data, {registry}) =>
        DUIYoutubePlayerBuilder.create(data),
    'digia/stack': (data, {registry}) => DUIStackBuilder.create(data),
    'digia/videoPlayer': (data, {registry}) => DUIVideoPlayer.create(data),
    'digia/tabView': (data, {registry}) =>
        DUITabViewBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/tabViewItem': (data, {registry}) =>
        DUITabViewItemBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/horizontalDivider': (data, {registry}) =>
        DUIHorizontalDividerBuilder.create(data),
    'digia/verticalDivider': (data, {registry}) =>
        DUIVerticalDividerBuilder.create(data),
    'digia/customDezervComponent': (data, {registry}) =>
        DUICustomWidgetBuilder.create(data),
    'digia/navigationBarItem': (data, {registry}) =>
        DUIBottomNavigationBarItemBuilder.create(data, registry: registry),
    'digia/textField': (data, {registry}) => DUITextFieldBuilder.create(data),
    'digia/stepper': (data, {registry}) =>
        DezervStepperBuilder.create(data, registry: DUIWidgetRegistry.shared),
    'digia/dezerv/dialPad': (data, {registry}) =>
        DUIDezervDialPadBuilder.create(data),
    'digia/futureBuilder': (data, {registry}) => DUIFutureBuilder(data: data),
    'digia/circularProgressIndicator': (data, {registry}) =>
        DUICircularProgressBarBuilder(data: data),
  };

  static const DUIWidgetRegistry shared = DUIWidgetRegistry();

  DUIWidgetBuilder? getBuilder(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    final builderFn = builders[data.type];

    return builderFn?.call(data,
        registry: registry ?? DUIWidgetRegistry.shared);
  }
}
