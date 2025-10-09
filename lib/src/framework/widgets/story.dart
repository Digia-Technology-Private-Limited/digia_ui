import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../data_type/adapted_types/story_controller.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_story.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import 'conditional_builder.dart';
import 'condtional_item.dart';
import 'story_items.dart';

class VWStory extends VirtualStatelessWidget<Props> {
  VWStory({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  bool get shouldRepeatChild => props.get('dataSource') != null;

  VirtualWidget? get header => childGroups?['header']?.firstOrNull;

  VirtualWidget? get footer => childGroups?['footer']?.firstOrNull;

  List<VirtualWidget>? get items => childGroups?['items'];

  @override
  Widget render(RenderPayload payload) {
    final controller =
        payload.eval<AdaptedStoryController>(props.get('controller')) ??
            AdaptedStoryController();

    // if (controller == null) {
    //   return const Center(
    //       child: Text('StoryController is required for VWStory'));
    // }

    final onCompleteAction = props.get('onComplete') as ActionFlow?;
    final repeat = props.getBool('repeat') ?? false;

    final headerWidget = header?.toWidget(payload);
    final footerWidget = footer?.toWidget(payload);

    List<StoryItem> storyItems = [];

    if (shouldRepeatChild) {
      final dataSource =
          payload.eval<List<Object>>(props.get('dataSource')) ?? [];
      final template = items?.firstOrNull;
      if (template is VWStoryItem) {
        for (var i = 0; i < dataSource.length; i++) {
          final itemData = dataSource[i];
          final itemPayload = payload.copyWithChainedContext(
            _createExprContext(itemData, i),
          );
          final storyItem = template.toStoryItem(itemPayload, controller);
          if (storyItem != null) {
            storyItems.add(storyItem);
          }
        }
      }
      if (template is VWConditionalBuilder) {
        for (var i = 0; i < dataSource.length; i++) {
          final itemData = dataSource[i];
          final itemPayload = payload.copyWithChainedContext(
            _createExprContext(itemData, i),
          );
          // Evaluate which conditional item should be used based on conditions
          final conditionalItem = template.children
              ?.whereType<VWConditionItem>()
              .firstWhereOrNull((e) => e.evaluate(itemPayload.scopeContext));

          if (conditionalItem != null) {
            final conditionalItemChild = conditionalItem.child;
            if (conditionalItemChild is VWStoryItem) {
              final storyItem =
                  conditionalItemChild.toStoryItem(itemPayload, controller);
              if (storyItem != null) {
                storyItems.add(storyItem);
              }
            }
          }
        }
      }
    } else {
      // Handle both direct VWStoryItem and VWConditionItem containing VWStoryItem
      storyItems = [];
      
      for (final item in items ?? []) {
        if (item is VWStoryItem) {
          // Direct story item
          final storyItem = item.toStoryItem(payload, controller);
          if (storyItem != null) {
            storyItems.add(storyItem);
          }
        } else if (item is VWConditionalBuilder) {
          // Conditional builder - evaluate conditions and get the active child
          final activeItem = item.children
              ?.whereType<VWConditionItem>()
              .firstWhereOrNull((e) => e.evaluate(payload.scopeContext));
          
          if (activeItem != null && activeItem.child is VWStoryItem) {
            final storyItem = (activeItem.child as VWStoryItem).toStoryItem(payload, controller);
            if (storyItem != null) {
              storyItems.add(storyItem);
            }
          }
        }
      }
    }
    if (storyItems.isEmpty) {
      return const Center(child: Text('No story items provided.'));
    }

    return InternalStory(
      controller: controller,
      storyItems: storyItems,
      repeat: repeat,
      header: headerWidget,
      footer: footerWidget,
      onComplete: () {
        if (onCompleteAction != null) {
          payload.executeAction(onCompleteAction);
        }
      },
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    final listObj = {
      'currentItem': item,
      'index': index,
    };

    return DefaultScopeContext(
      variables: {
        ...listObj,
        ...?refName.maybe((it) => {it: listObj}),
      },
    );
  }
}