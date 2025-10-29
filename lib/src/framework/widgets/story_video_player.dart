import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_story_video_player.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWStoryVideoPlayer extends VirtualLeafStatelessWidget<Props> {
  VWStoryVideoPlayer({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final videoUrl = payload.eval<String>(props.get('videoUrl'));
    if (videoUrl == null || videoUrl.isEmpty) return empty();

    final autoPlay = payload.eval<bool>(props.get('autoPlay')) ?? true;
    final looping = payload.eval<bool>(props.get('looping')) ?? false;
    final fit = To.boxFit(props.get('fit'));

    return InternalStoryVideoPlayer(
      key: ValueKey('story_video_${videoUrl.hashCode}'),
      videoUrl: videoUrl,
      autoPlay: autoPlay,
      looping: looping,
      fit: fit,
    );
  }
}
