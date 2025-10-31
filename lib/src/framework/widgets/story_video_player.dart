import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_story_video_player.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/story_video_player_props.dart';

class VWStoryVideoPlayer
    extends VirtualLeafStatelessWidget<StoryVideoPlayerProps> {
  VWStoryVideoPlayer({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final videoUrl = props.videoUrl?.evaluate(payload.scopeContext);
    if (videoUrl == null || videoUrl.isEmpty) return empty();

    final autoPlay = props.autoPlay?.evaluate(payload.scopeContext) ?? true;
    final looping = props.looping?.evaluate(payload.scopeContext) ?? false;
    final fit = To.boxFit(props.fit?.evaluate(payload.scopeContext));

    return InternalStoryVideoPlayer(
      key: ValueKey('story_video_${videoUrl.hashCode}'),
      videoUrl: videoUrl,
      autoPlay: autoPlay,
      looping: looping,
      fit: fit,
    );
  }
}
