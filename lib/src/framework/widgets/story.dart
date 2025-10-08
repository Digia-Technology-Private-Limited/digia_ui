
//not optimised code as conditional builders were giving errors------------------


import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../widget_props/story_item_props.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../models/props.dart';
import '../actions/base/action_flow.dart';
import 'conditional_builder.dart';
import 'condtional_item.dart';
class VWStory extends VirtualStatelessWidget<Props> {
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
    final storyItems = _convertToStoryItems(payload);
    if (storyItems.isEmpty) return const SizedBox.shrink();
    return FlutterStoryPresenter(
      initialIndex: payload.eval<int>(props.get('initialIndex')) ?? 0,
      restartOnCompleted: payload.eval<bool>(props.get('restartOnCompleted')) ?? true,
      storyViewIndicatorConfig: _buildIndicatorConfig(payload),
      items: storyItems,
      headerWidget: childOf('header')?.toWidget(payload),
      footerWidget: childOf('footer')?.toWidget(payload),
      onSlideDown: _buildSlideDownCallback('onSlideDown', payload),
      onSlideStart: _buildSlideStartCallback('onSlideStart', payload),
      onLeftTap: _buildAsyncActionCallback('onLeftTap', payload),
      onRightTap: _buildAsyncActionCallback('onRightTap', payload),
      onCompleted: _buildAsyncActionCallback('onCompleted', payload),
      onPreviousCompleted: _buildAsyncActionCallback('onPreviousCompleted', payload),
      onStoryChanged: _buildStoryChangedCallback('onStoryChanged', payload),
    );
  }
  List<StoryItem> _convertToStoryItems(RenderPayload payload) {
    final storyItems = <StoryItem>[];
    // Check if we should use data source iteration
    final shouldRepeatChild = props.get('dataSource') != null;
    if (shouldRepeatChild) {
      // Use data source for dynamic iteration
      final items = payload.eval<List<Object>>(props.get('dataSource')) ?? [];
      for (int index = 0; index < items.length; index++) {
        final dataItem = items[index];
        final scopedPayload = payload.copyWithChainedContext(
          _createExprContext(dataItem, index),
        );
        // Let conditional builder choose the right story item template
        final itemsGroup = childGroups?['items'] ?? [];
        for (final item in itemsGroup) {
          if (item is VWStoryItem) {
            final storyItem = _convertStoryItemWidget(item, scopedPayload);
            if (storyItem != null) {
              storyItems.add(storyItem);
              break; // Only use the first valid story item from conditional builder
            }
          } else if (item is VWConditionalBuilder) {
            // Evaluate the conditional builder to get the selected story item
            final conditionalChildren = item.childGroups?['children'] ?? [];
            final conditionalItems = conditionalChildren.whereType<VWConditionItem>();
            // Find the first conditional item that evaluates to true
            final activeConditionalItem = conditionalItems.firstWhereOrNull(
              (conditionalItem) => conditionalItem.evaluate(scopedPayload.scopeContext) == true
            );
            // If we found an active conditional item, check if it contains a story item
            if (activeConditionalItem != null) {
              final storyItemChild = activeConditionalItem.child;
              if (storyItemChild is VWStoryItem) {
                final storyItem = _convertStoryItemWidget(storyItemChild, scopedPayload);
                if (storyItem != null) {
                  storyItems.add(storyItem);
                }
              }
            }
          }
        }
      }
    } else {
      // Use static items
      final items = childGroups?['items'] ?? [];
      for (final item in items) {
        if (item is VWStoryItem) {
          final storyItem = _convertStoryItemWidget(item, payload);
          if (storyItem != null) {
            storyItems.add(storyItem);
          }
        } else if (item is VWConditionalBuilder) {
          // Evaluate the conditional builder to get the selected story item
          final conditionalChildren = item.childGroups?['children'] ?? [];
          final conditionalItems = conditionalChildren.whereType<VWConditionItem>();
          // Find the first conditional item that evaluates to true
          final activeConditionalItem = conditionalItems.firstWhereOrNull(
            (conditionalItem) => conditionalItem.evaluate(payload.scopeContext) == true
          );
          // If we found an active conditional item, check if it contains a story item
          if (activeConditionalItem != null) {
            final storyItemChild = activeConditionalItem.child;
            if (storyItemChild is VWStoryItem) {
              final storyItem = _convertStoryItemWidget(storyItemChild, payload);
              if (storyItem != null) {
                storyItems.add(storyItem);
              }
            }
          }
        }
      }
    }
    return storyItems;
  }
  StoryItem? _convertStoryItemWidget(VWStoryItem itemWidget, RenderPayload payload) {
    // Properly handle ExprOr types to avoid validation errors
    final storyItemType = itemWidget.props.storyItemType != null
        ? payload.evalExpr(itemWidget.props.storyItemType) ?? 'image'
        : 'image';
    final url = itemWidget.props.url != null
        ? payload.evalExpr(itemWidget.props.url)
        : null;
    final durationMs = itemWidget.props.durationMs != null
        ? payload.evalExpr(itemWidget.props.durationMs) ?? 3000
        : 3000;
    final source = itemWidget.props.source != null
        ? payload.evalExpr(itemWidget.props.source) ?? 'network'
        : 'network';
    final isMuteByDefault = itemWidget.props.isMuteByDefault != null
        ? payload.evalExpr(itemWidget.props.isMuteByDefault) ?? false
        : false;
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
    //will remove in future version-------
    Widget loadingWidget = Container(
      color: Colors.grey[100],
      child: const Center(
        child: CupertinoActivityIndicator(),
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
  ScopeContext _createExprContext(Object? item, int index) {
    final storyObj = {
      'currentItem': item,
      'index': index,
    };
    return DefaultScopeContext(variables: {
      ...storyObj,
      ...?refName?.maybe((it) => {it: storyObj}),
    });
  }
  StoryViewIndicatorConfig _buildIndicatorConfig(RenderPayload payload) {
    final indicator = props.get('indicator') as Map<String, dynamic>?;
    return StoryViewIndicatorConfig(
      activeColor: payload.evalColor(indicator?['activeColor']) ?? Colors.blue,
      backgroundCompletedColor: payload.evalColor(indicator?['backgroundCompletedColor']) ?? Colors.white,
      backgroundDisabledColor: payload.evalColor(indicator?['backgroundDisabledColor']) ?? Colors.grey,
      height: (indicator?['height'] as num?)?.toDouble() ?? 3.5,
      borderRadius: (indicator?['borderRadius'] as num?)?.toDouble() ?? 4.0,
      horizontalGap: (indicator?['horizontalGap'] as num?)?.toDouble() ?? 4.0,
    );
  }
  void Function(DragUpdateDetails)? _buildSlideDownCallback(String actionName, RenderPayload payload) {
    if (props.get(actionName) == null) return null;
    return (details) {
      final action = ActionFlow.fromJson(props.get(actionName));
      payload.executeAction(action);
    };
  }
  void Function(DragStartDetails)? _buildSlideStartCallback(String actionName, RenderPayload payload) {
    if (props.get(actionName) == null) return null;
    return (details) {
      final action = ActionFlow.fromJson(props.get(actionName));
      payload.executeAction(action);
    };
  }
  void Function(int)? _buildStoryChangedCallback(String actionName, RenderPayload payload) {
    if (props.get(actionName) == null) return null;
    return (index) {
      final action = ActionFlow.fromJson(props.get(actionName));
      payload.executeAction(action);
    };
  }
  Future<bool> Function()? _buildAsyncActionCallback(String actionName, RenderPayload payload) {
    if (props.get(actionName) == null) return null;
    return () async {
      final action = ActionFlow.fromJson(props.get(actionName));
      payload.executeAction(action);
      return true;
    };
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
