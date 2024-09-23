import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../models/dui_file.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';

class VWVideoPlayer extends VirtualLeafStatelessWidget {
  VWVideoPlayer({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  VideoPlayerController _createController(RenderPayload payload) {
    final videoSource = payload.eval(props.get('videoUrl'));

    if (videoSource is List<DUIFile> && videoSource.isNotEmpty) {
      final firstFile = videoSource.first;
      if (firstFile.isMobile) {
        return VideoPlayerController.file(File(firstFile.path!));
      } else if (firstFile.isWeb) {
        return VideoPlayerController.networkUrl(
            Uri.parse(firstFile.xFile!.path));
      }
      throw Exception('Invalid DUIFile source in list');
    }

    if (videoSource is DUIFile) {
      return VideoPlayerController.networkUrl(
          Uri.parse(videoSource.xFile!.path));
    }

    if (videoSource is String) {
      if (videoSource.startsWith('http')) {
        return VideoPlayerController.networkUrl(Uri.parse(videoSource));
      }
    }

    throw Exception('Unsupported video source type');
  }

  @override
  Widget render(RenderPayload payload) {
    ChewieController chewieController = ChewieController(
      allowMuting: true,
      errorBuilder: (context, error) {
        return Center(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.4,
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.info,
                  color: Colors.red,
                  size: MediaQuery.sizeOf(context).height * 0.1,
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
      showControls: payload.eval<bool>(props.get('showControls')) ?? true,
      aspectRatio: props.getDouble('aspectRatio'),
      allowPlaybackSpeedChanging: true,
      playbackSpeeds: [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2],
      videoPlayerController: _createController(payload),
      autoPlay: payload.eval<bool>(props.get('autoPlay')) ?? true,
      looping: payload.eval<bool>(props.get('looping')) ?? false,
      subtitle: Subtitles(
        [
          Subtitle(
            index: 0,
            start: Duration.zero,
            end: const Duration(seconds: 10),
            text: '',
          ),
        ],
      ),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(text: subtitle)
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
