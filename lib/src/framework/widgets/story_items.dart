import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import 'package:flutter/cupertino.dart';
import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/story_item_props.dart';

class VWStoryItem extends VirtualStatelessWidget<StoryItemProps> {
  VWStoryItem({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });
  final loadingWidget = Container(
      color: Colors.grey[100],
      child: const Center(child: CupertinoActivityIndicator()),
);
  StoryItem? toStoryItem(
      RenderPayload payload, FlutterStoryController controller) {
    // Properly evaluate the ExprOr values
    final type = props.storyItemType?.evaluate(payload.scopeContext);
    final url = props.url?.evaluate(payload.scopeContext);
    final duration = props.durationInMs?.evaluate(payload.scopeContext);
    final durationTransformed = duration != null
        ? Duration(milliseconds: duration)
        : const Duration(seconds: 3);


    switch (type) {
      case 'image':
        if (url == null) {
          return null;
        }
        return StoryItem(
          storyItemType: StoryItemType.image,
          url: url,
          thumbnail: loadingWidget,
          duration: durationTransformed,
          imageConfig: props.imageConfig != null 
              ? StoryViewImageConfig(
                  fit: To.boxFit(payload.eval(props.imageConfig?['fit']) ?? 'cover'),
                )
              : null,
        );
      case 'video':
        if (url == null) {
          return null;
        }
        return StoryItem(
          storyItemType: StoryItemType.video,
          url: url,
          thumbnail: loadingWidget,
          duration: durationTransformed,
          videoConfig: props.videoConfig != null
              ? StoryViewVideoConfig(
                  fit: To.boxFit(payload.eval(props.videoConfig?['fit'])),
                )
              : null,
        );
      case 'custom':
        final childWidget = child?.toWidget(payload);
        if (childWidget == null) {
          return null;
        }
        return StoryItem(
          storyItemType: StoryItemType.custom,
          customWidget: (context, storyController) => childWidget,
          duration: durationTransformed,
        );
      default:
        return null;
    }
  }

  @override
  Widget render(RenderPayload payload) {
    return const SizedBox.shrink();
  }
}
