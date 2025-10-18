import 'package:collection/collection.dart';
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
  Widget empty() => const SizedBox.shrink();

  @override
  Widget render(RenderPayload payload) {
    if (items == null || items!.isEmpty) return empty();

    final controller =
        payload.eval<AdaptedStoryController>(props.get('controller')) ??
            AdaptedStoryController();

    final onCompleteAction = props.get('onComplete') as ActionFlow?;
    final repeat = props.getBool('restartOnCompleted') ?? false;
    final duration = props.getInt('duration') ?? 3000;

    final headerWidget = header?.toWidget(payload);
    final footerWidget = footer?.toWidget(payload);

    final indicator = props.get('indicator') as Map<String, dynamic>?;
    final storyViewIndicatorConfig = StoryViewIndicatorConfig(
      activeColor: payload.evalColor(indicator?['activeColor']) ?? Colors.blue,
      backgroundCompletedColor: payload.evalColor(indicator?['backgroundCompletedColor']) ?? Colors.white,
      backgroundDisabledColor: payload.evalColor(indicator?['backgroundDisabledColor']) ?? Colors.grey,
      height: (indicator?['height'] as num?)?.toDouble() ?? 3.5,
      borderRadius: (indicator?['borderRadius'] as num?)?.toDouble() ?? 4.0,
      horizontalGap: (indicator?['horizontalGap'] as num?)?.toDouble() ?? 4.0,
    );

    if (shouldRepeatChild) {
      final dataSource = payload.eval<List<Object>>(props.get('dataSource')) ?? [];
      final template = items?.firstOrNull;
      
      return InternalStory(
        controller: controller,
        widgets: dataSource.asMap().entries.map((entry) {
          final index = entry.key;
          final itemData = entry.value;
          return template?.toWidget(
            payload.copyWithChainedContext(
              _createExprContext(itemData, index),
            ),
          ) ?? empty();
        }).toList(),
        repeat: repeat,
        storyViewIndicatorConfig: storyViewIndicatorConfig,
        header: headerWidget,
        footer: footerWidget,
        defaultDuration: Duration(milliseconds: duration),
        onComplete: () {
          if (onCompleteAction != null) {
            payload.executeAction(onCompleteAction);
          }
        },
      );
    }

    return InternalStory(
      controller: controller,
      widgets: items!.map((item) => item.toWidget(payload)).toList(),
      repeat: repeat,
      storyViewIndicatorConfig: storyViewIndicatorConfig,
      header: headerWidget,
      footer: footerWidget,
      defaultDuration: Duration(milliseconds: duration),
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