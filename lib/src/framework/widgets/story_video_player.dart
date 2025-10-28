import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_story_video_player.dart';
import '../models/props.dart';
import '../render_payload.dart';

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
    final videoUrl = payload.eval(props.get('videoUrl'));
    
    if (videoUrl == null) {
      debugPrint('StoryVideoPlayer: videoUrl is null');
      return empty();
    }
    
    String? urlString;
    if (videoUrl is String) {
      if (videoUrl.isEmpty) {
        debugPrint('StoryVideoPlayer: videoUrl is empty');
        return empty();
      }
      urlString = videoUrl;
    } else {
      debugPrint('StoryVideoPlayer: videoUrl is not a string: ${videoUrl.runtimeType}');
      return empty();
    }

    final autoPlay = payload.eval<bool>(props.get('autoPlay')) ?? true;
    final looping = payload.eval<bool>(props.get('looping')) ?? false;
    final fit = _parseBoxFit(props.get('fit'));

    /// Unique key based on video URL ensures proper widget rebuilding when URL changes
    final videoKey = _generateVideoKey(urlString);
    debugPrint('StoryVideoPlayer: Rendering with key: $videoKey, videoUrl: $urlString');

    return InternalStoryVideoPlayer(
      key: ValueKey(videoKey),
      videoUrl: urlString,
      autoPlay: autoPlay,
      looping: looping,
      fit: fit,
    );
  }

  String _generateVideoKey(String videoUrl) {
    return 'video_${videoUrl.hashCode}';
  }

  BoxFit? _parseBoxFit(dynamic fitValue) {
    if (fitValue == null) return BoxFit.cover;
    
    final fitString = fitValue.toString().toLowerCase();
    switch (fitString) {
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fill':
        return BoxFit.fill;
      case 'fitwidth':
        return BoxFit.fitWidth;
      case 'fitheight':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaledown':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }
}
