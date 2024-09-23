import 'package:flutter/widgets.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_youtube_player.dart';
import '../render_payload.dart';

class VWYoutubePlayer extends VirtualLeafStatelessWidget {
  VWYoutubePlayer({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    return InternalYoutubePlayer(
      videoUrl: payload.eval<String>(props.get('videoUrl')) ?? '',
      isMuted: payload.eval<bool>(props.get('isMuted')) ?? false,
      loop: payload.eval<bool>(props.get('loop')) ?? false,
      autoPlay: payload.eval<bool>(props.get('autoPlay')) ?? false,
    );
  }
}
