import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_video_player.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWVideoPlayer extends VirtualLeafStatelessWidget<Props> {
  VWVideoPlayer({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final videoSource = payload.eval(props.get('videoUrl'));
    if (videoSource == null) return empty();

    return InternalVideoPlayer(
      videoUrl: videoSource,
      showControls: payload.eval<bool>(props.get('showControls')),
      aspectRatio: props.getDouble('aspectRatio'),
      autoPlay: payload.eval<bool>(props.get('autoPlay')),
      looping: payload.eval<bool>(props.get('looping')),
    );
  }
}
