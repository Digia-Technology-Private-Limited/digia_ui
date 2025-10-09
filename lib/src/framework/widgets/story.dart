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

    // Determine if dynamic iteration is needed
    final dataSource = props.get('dataSource');
    if (dataSource != null) {
      final items = payload.eval<List<Object>>(dataSource) ?? [];
      for (int index = 0; index < items.length; index++) {
        final scopedPayload = payload.copyWithChainedContext(
          _createExprContext(items[index], index),
        );
        _addStoryItemsFromGroup(storyItems, childGroups?['items'] ?? [], scopedPayload);
      }
    } else {
      _addStoryItemsFromGroup(storyItems, childGroups?['items'] ?? [], payload);
    }

    return storyItems;
  }

  void _addStoryItemsFromGroup(List<StoryItem> storyItems, List<dynamic> groupItems, RenderPayload payload) {
    for (final item in groupItems) {
      if (item is VWStoryItem) {
        final storyItem = _convertStoryItemWidget(item, payload);
        if (storyItem != null) storyItems.add(storyItem);
      } else if (item is VWConditionalBuilder) {
        _addConditionalStoryItem(storyItems, item, payload);
      }
    }
  }

  void _addConditionalStoryItem(List<StoryItem> storyItems, VWConditionalBuilder builder, RenderPayload payload) {
    final conditionalItems = builder.childGroups?['children']?.whereType<VWConditionItem>() ?? [];
    final activeItem = conditionalItems.firstWhereOrNull(
      (item) => item.evaluate(payload.scopeContext) == true,
    );
    if (activeItem != null && activeItem.child is VWStoryItem) {
      final storyItem = _convertStoryItemWidget(activeItem.child as VWStoryItem, payload);
      if (storyItem != null) storyItems.add(storyItem);
    }
  }

  StoryItem? _convertStoryItemWidget(VWStoryItem itemWidget, RenderPayload payload) {
    final storyItemType = payload.evalExpr(itemWidget.props.storyItemType) ?? 'image';
    final url = payload.evalExpr(itemWidget.props.url);
    if (url == null || url.isEmpty) return null;

    final type = switch (storyItemType) {
      'image' => StoryItemType.image,
      'video' => StoryItemType.video,
      _ => StoryItemType.image,
    };

    final source = payload.evalExpr(itemWidget.props.source) ?? 'network';
    final itemSource = source == 'asset' ? StoryItemSource.asset : StoryItemSource.network;

    final durationInMs = payload.evalExpr(itemWidget.props.durationInMs) ?? 3000;
    final isMuteByDefault = payload.evalExpr(itemWidget.props.isMuteByDefault) ?? false;

    StoryViewVideoConfig? videoConfig;
    if (type == StoryItemType.video && itemWidget.props.videoConfig != null) {
      videoConfig = StoryViewVideoConfig(fit: To.boxFit(itemWidget.props.videoConfig?['fit']));
    }

    StoryViewImageConfig? imageConfig;
    if (type == StoryItemType.image && itemWidget.props.imageConfig != null) {
      imageConfig = StoryViewImageConfig(fit: To.boxFit(itemWidget.props.imageConfig?['fit']));
    }

    final loadingWidget = Container(
      color: Colors.grey[100],
      child: const Center(child: CupertinoActivityIndicator()),
    );

    return StoryItem(
      url: url,
      storyItemType: type,
      duration: Duration(milliseconds: durationInMs),
      storyItemSource: itemSource,
      isMuteByDefault: isMuteByDefault,
      thumbnail: loadingWidget,
      videoConfig: videoConfig,
      imageConfig: imageConfig,
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    final storyObj = {'currentItem': item, 'index': index};
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
    final actionData = props.get(actionName);
    if (actionData == null) return null;
    return (details) => payload.executeAction(ActionFlow.fromJson(actionData));
  }

  void Function(DragStartDetails)? _buildSlideStartCallback(String actionName, RenderPayload payload) {
    final actionData = props.get(actionName);
    if (actionData == null) return null;
    return (details) => payload.executeAction(ActionFlow.fromJson(actionData));
  }

  void Function(int)? _buildStoryChangedCallback(String actionName, RenderPayload payload) {
    final actionData = props.get(actionName);
    if (actionData == null) return null;
    return (index) => payload.executeAction(ActionFlow.fromJson(actionData));
  }

  Future<bool> Function()? _buildAsyncActionCallback(String actionName, RenderPayload payload) {
    final actionData = props.get(actionName);
    if (actionData == null) return null;
    return () async {
      payload.executeAction(ActionFlow.fromJson(actionData));
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
  Widget render(RenderPayload payload) => const SizedBox.shrink();
}
