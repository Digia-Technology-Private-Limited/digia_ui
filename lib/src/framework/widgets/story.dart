import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';

import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../widget_props/story_item_props.dart';
import '../widget_props/story_props.dart';
import '../utils/flutter_type_converters.dart';

class VWStory extends VirtualStatelessWidget<StoryProps> {
  VWStory({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
  });

  @override
  Widget render(RenderPayload payload) {
    final initialIndex = payload.evalExpr(props.initialIndex) ?? 0;
    final restartOnCompleted = payload.evalExpr(props.restartOnCompleted) ?? true;
    final indicator = props.indicator;

    final header = childOf('header')?.toWidget(payload);
    final footer = childOf('footer')?.toWidget(payload);

    // Convert child groups to StoryItem list
    final storyItems = _convertToStoryItems(payload);

    if (storyItems.isEmpty) {
      // Show nothing when no story items
      return const SizedBox.shrink();
    }

    // Configure indicator
    final indicatorConfig = StoryViewIndicatorConfig(
      activeColor: payload.evalColor(indicator?['activeColor']) ?? Colors.blue,
      backgroundCompletedColor: payload.evalColor(indicator?['backgroundCompletedColor']) ?? Colors.white,
      backgroundDisabledColor: payload.evalColor(indicator?['backgroundDisabledColor']) ?? Colors.grey,
      height: (indicator?['height'] as num?)?.toDouble() ?? 3.5,
      borderRadius: (indicator?['borderRadius'] as num?)?.toDouble() ?? 4.0,
      horizontalGap: (indicator?['horizontalGap'] as num?)?.toDouble() ?? 4.0,
    );

    return FlutterStoryPresenter(
      initialIndex: initialIndex,
      restartOnCompleted: restartOnCompleted,
      storyViewIndicatorConfig: indicatorConfig,
      items: storyItems,
      headerWidget: header,
      footerWidget: footer,
      
      // Gesture callbacks
      onSlideDown: props.onSlideDown != null ? (details) {
        payload.executeAction(props.onSlideDown!);
      } : null,
      
      onSlideStart: props.onSlideStart != null ? (details) {
        payload.executeAction(props.onSlideStart!);
      } : null,
      
      // Tap callbacks - always provide callbacks for default navigation behavior
      onLeftTap: () async {
        if (props.onLeftTap != null) {
          payload.executeAction(props.onLeftTap!);
        }
        return true; // Always allow navigation
      },
      
      onRightTap: () async {
        if (props.onRightTap != null) {
          payload.executeAction(props.onRightTap!);
        }
        return true; // Always allow navigation
      },
      
      // Story lifecycle callbacks
      onCompleted: props.onCompleted != null ? () async {
        payload.executeAction(props.onCompleted!);
      } : null,
      
      onPreviousCompleted: props.onPreviousCompleted != null ? () async {
        payload.executeAction(props.onPreviousCompleted!);
      } : null,
      
      onStoryChanged: props.onStoryChanged != null ? (index) {
        payload.executeAction(props.onStoryChanged!);
      } : null,
    );
  }

  List<StoryItem> _convertToStoryItems(RenderPayload payload) {
    final items = childGroups?['items'] ?? [];
    final storyItems = <StoryItem>[];

    for (final item in items) {
      // Access the VWStoryItem directly from the child data
      if (item is VWStoryItem) {
        final storyItem = _convertStoryItemWidget(item, payload);
        if (storyItem != null) {
          storyItems.add(storyItem);
        }
      }
    }

    return storyItems;
  }

  StoryItem? _convertStoryItemWidget(VWStoryItem itemWidget, RenderPayload payload) {
    final storyItemType = payload.evalExpr(itemWidget.props.storyItemType) ?? 'image';
    final url = payload.evalExpr(itemWidget.props.url);
    final durationMs = payload.evalExpr(itemWidget.props.durationMs) ?? 3000;
    final source = payload.evalExpr(itemWidget.props.source) ?? 'network';
    final isMuteByDefault = payload.evalExpr(itemWidget.props.isMuteByDefault) ?? false;
    final videoConfig = itemWidget.props.videoConfig;
    final imageConfig = itemWidget.props.imageConfig;
    
    // Skip story items without valid URLs
    if (url == null || url.isEmpty) {
      return null;
    }
    
    // Convert story item type
    StoryItemType type;
    switch (storyItemType) {
      case 'image':
        type = StoryItemType.image;
        break;
      case 'video':
        type = StoryItemType.video;
        break;
      default:
        type = StoryItemType.image;
    }

    // Convert source
    final itemSource = switch (source) {
      'asset' => StoryItemSource.asset,
      _ => StoryItemSource.network,
    };

    // Convert video config
    StoryViewVideoConfig? videoConfigObj;
    if (videoConfig != null && type == StoryItemType.video) {
      videoConfigObj = StoryViewVideoConfig(
        fit: To.boxFit(videoConfig['fit']),
      );
    }


    // Convert image config
    StoryViewImageConfig? imageConfigObj;
    if (imageConfig != null && type == StoryItemType.image) {
      imageConfigObj = StoryViewImageConfig(
        fit: To.boxFit(imageConfig['fit']),
      );
    }


    // Create default loading widget (circular progress bar)
    Widget loadingWidget = Container(
      color: Colors.grey[100],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
    );

    return StoryItem(
      url: url,
      storyItemType: type,
      duration: Duration(milliseconds: durationMs),
      storyItemSource: itemSource,
      isMuteByDefault: isMuteByDefault,
      thumbnail: loadingWidget,
      videoConfig: videoConfigObj,
      imageConfig: imageConfigObj,
    );
  }


}

class VWStoryItem extends VirtualStatelessWidget<StoryItemProps> {
  VWStoryItem({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
  });

  @override
  Widget render(RenderPayload payload) {
    // Story items are data-only nodes that get converted to StoryItem objects
    // They don't render directly in the builder, only when used in FlutterStoryPresenter
    return const SizedBox.shrink();
  }
}

// builders are defined in builders.dart to match architecture


