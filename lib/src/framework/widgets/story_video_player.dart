import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_story_video_player.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/story_video_player_props.dart';

class VWStoryVideoPlayer extends VirtualLeafStatelessWidget<StoryVideoPlayerProps> {
  VWStoryVideoPlayer({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final videoUrl = payload.eval<String>(props.videoUrl);
    if (videoUrl == null || videoUrl.isEmpty) return empty();

    final autoPlay = payload.eval<bool>(props.autoPlay) ?? true;
    final looping = payload.eval<bool>(props.looping) ?? false;
    final fit = To.boxFit(payload.eval<String>(props.fit));

    return InternalStoryVideoPlayer(
      key: ValueKey('story_video_${videoUrl.hashCode}'),
      videoUrl: videoUrl,
      autoPlay: autoPlay,
      looping: looping,
      fit: fit,
    );
  }
}
