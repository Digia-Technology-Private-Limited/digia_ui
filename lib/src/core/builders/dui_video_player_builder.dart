import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIVideoPlayer extends DUIWidgetBuilder {
  DUIVideoPlayer({required super.data});

  static DUIVideoPlayer? create(DUIWidgetJsonData data) {
    return DUIVideoPlayer(data: data);
  }

  @override
  Widget build(BuildContext context) {
    VideoPlayerController videoPlayerController1 =
        VideoPlayerController.networkUrl(
      Uri.parse(data.props['videoUrl'] as String),
    );

    ChewieController chewieController = ChewieController(
      allowMuting: true,
      errorBuilder: (context1, error) {
        return Center(
          child: SizedBox(
            height: MediaQuery.sizeOf(context1).height * 0.4,
            width: MediaQuery.sizeOf(context1).width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.info,
                  color: Colors.red,
                  size: MediaQuery.sizeOf(context1).height * 0.1,
                ),
                Text(
                  error,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        );
      },
      showControls:
          eval<bool>(data.props['showControls'], context: context) ?? true,
      aspectRatio: NumDecoder.toDouble(data.props['aspectRatio']),
      allowPlaybackSpeedChanging: true,
      playbackSpeeds: [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2],
      videoPlayerController: videoPlayerController1,
      autoPlay: eval<bool>(data.props['autoPlay'], context: context) ?? true,
      looping: eval<bool>(data.props['looping'], context: context) ?? false,
      subtitle: Subtitles(
        [
          Subtitle(
              index: 0,
              start: Duration.zero,
              end: const Duration(seconds: 10),
              text: ''),
        ],
      ),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),
      hideControlsTimer: const Duration(seconds: 1),
      autoInitialize: true,
    );
    return Chewie(
      controller: chewieController,
    );
  }
}
