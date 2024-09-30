import 'base/virtual_state_container_widget.dart';
import 'base/virtual_widget.dart';
import 'builders.dart';
import 'models/vw_node_data.dart';

typedef VirtualWidgetBuilder = VirtualWidget Function(
    VWNodeData data, VirtualWidget? parent, VirtualWidgetRegistry registry);

class VirtualWidgetRegistry {
  final Map<String, VirtualWidgetBuilder> _builders = {
    // Layout Widgets
    'digia/container': containerBuilder,
    'digia/column': columnBuilder,
    'digia/row': rowBuilder,
    'digia/flexFit': flexFitBuilder,
    'digia/stack': stackBuilder,
    'digia/listView': listViewBuilder,
    'digia/gridView': gridViewBuilder,
    'digia/wrap': wrapBuilder,
    'fw/sized_box': sizedBoxBuilder,
    'fw/spacer': spacerBuilder,
    'digia/safeArea': safeAreaBuilder,
    // 'digia/customScrollView': customScrollViewBuilder,
    // 'digia/nestedScrollView': nestedScrollViewBuilder,

    // Basic Widgets
    'digia/text': textBuilder,
    'digia/richText': richTextBuilder,
    'digia/icon': iconBuilder,
    'digia/image': imageBuilder,
    'digia/button': buttonBuilder,
    'digia/iconButton': iconButtonBuilder,
    'digia/checkbox': checkboxBuilder,
    'digia/switch': switchBuilder,
    // 'digia/textFormField': textFormFieldBuilder,

    // Navigation and Structure
    'digia/scaffold': scaffoldBuilder,
    'fw/scaffold': scaffoldBuilder,
    'fw/appBar': appBarBuilder,
    'digia/appBar': appBarBuilder,
    // 'digia/sliverAppBar': sliverAppBarBuilder,
    'digia/drawer': drawerBuilder,
    // 'digia/tabView': tabViewBuilder,
    // 'digia/tabViewItem': tabViewItemBuilder,
    // 'digia/navigationBarItem': navigationBarItemBuilder,

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
    // 'digia/stepper': stepperBuilder,
    // 'digia/flutterStepper': flutterStepperBuilder,
    'digia/pinField': pinFieldBuilder,
    'digia/calendar': calendarBuilder,

    // Media and Web Content
    'digia/lottie': lottieBuilder,
    'digia/youtubePlayer': youtubePlayerBuilder,
    'digia/videoPlayer': videoPlayerBuilder,
    'digia/htmlView': htmlViewBuilder,
    'digia/webView': webViewBuilder,

    // Data Display
    // 'digia/carousel': carouselBuilder,
    // 'digia/lineChart': lineChartBuilder,
    'digia/circularProgressBar': circularProgressBarBuilder,
    'digia/linearProgressBar': linearProgressBarBuilder,
    // 'digia/paginatedListView': paginatedListViewBuilder,
    // 'digia/sliverList': sliverListBuilder,

    // Async Widgets
    'digia/futureBuilder': asyncBuilderBuilder,
    'digia/asyncBuilder': asyncBuilderBuilder,
    'digia/streamBuilder': streamBuilderBuilder,

    // Utility Widgets
    // 'digia/conditionalBuilder': conditionalBuilderBuilder,
    'digia/opacity': opacityBuilder,
    // 'digia/animationBuilder': animationBuilderBuilder,
    'digia/timer': timerBuilder,

    // Custom and Specialized Widgets
    // 'digia/customDezervComponent': customDezervComponentBuilder,
    // 'digia/dezerv/dialPad': dezervDialPadBuilder,
    // 'digia/customShapeCard': customShapeCardBuilder,
    // 'digia/probo/animated_fastscore': proboCustomComponentBuilder,
  };

  void registerWidget(
      String type,
      VirtualWidget Function(
        VWNodeData data,
        VirtualWidgetRegistry registry,
      ) virtualWidgetBuilder) {
    _builders[type] =
        (data, _, registry) => virtualWidgetBuilder(data, registry);
  }

  static final VirtualWidgetRegistry instance =
      VirtualWidgetRegistry._internal();

  factory VirtualWidgetRegistry() {
    return instance;
  }

  VirtualWidgetRegistry._internal();

  VirtualWidget createWidget(VWNodeData data, VirtualWidget? parent) {
    if (data.category == 'state_container') {
      final child = data.childGroups?.entries.first.value.first;
      return VirtualStateContainerWidget(
        refName: data.refName,
        parent: parent,
        initialState: {},
        child: child == null ? null : createWidget(child, parent),
      );
    }

    String type = data.type;
    if (!_builders.containsKey(type)) {
      throw Exception('Unknown widget type: $type');
    }

    return _builders[type]!(data, parent, this);
  }

  VirtualWidget? createChild(
      {required VWNodeData data, String key = 'child', VirtualWidget? parent}) {
    final child = data.childGroups?[key]?.firstOrNull;

    if (child == null) return null;

    return createWidget(child, parent);
  }

  List<VirtualWidget?>? createChildren(
      {required VWNodeData data,
      String key = 'children',
      VirtualWidget? parent}) {
    final children = data.childGroups?[key];

    if (children == null || children.isEmpty) return null;

    return children.map((p0) => createChild(data: p0, parent: parent)).toList();
  }
}
