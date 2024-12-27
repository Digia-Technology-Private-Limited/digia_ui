import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../digia_ui_client.dart';
import '../../dui_dev_config.dart';
import '../data_type/adapted_types/file.dart';

class InternalVideoPlayer extends StatefulWidget {
  final Object videoUrl;
  final bool? showControls;
  final double? aspectRatio;
  final bool? autoPlay;
  final bool? looping;

  const InternalVideoPlayer({
    super.key,
    required this.videoUrl,
    this.showControls,
    this.aspectRatio,
    this.autoPlay,
    this.looping,
  });

  @override
  State<InternalVideoPlayer> createState() => _InternalVideoPlayerState();
}

class _InternalVideoPlayerState extends State<InternalVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _videoPlayerController = _createController(widget.videoUrl);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      allowMuting: true,
      errorBuilder: (context, error) => Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.info,
                color: Colors.red,
                size: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                error,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      showControls: widget.showControls ?? true,
      aspectRatio: widget.aspectRatio,
      allowPlaybackSpeedChanging: true,
      playbackSpeeds: [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2],
      autoPlay: widget.autoPlay ?? true,
      looping: widget.looping ?? false,
      hideControlsTimer: const Duration(seconds: 1),
      autoInitialize: true,
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
      subtitleBuilder: (context, subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(text: subtitle)
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),
    );
  }

  VideoPlayerController _createController(Object videoSource) {
    if (videoSource is List<AdaptedFile> && videoSource.isNotEmpty) {
      final firstFile = videoSource.first;
      if (firstFile.isMobile) {
        return VideoPlayerController.file(File(firstFile.path!));
      } else if (firstFile.isWeb) {
        return VideoPlayerController.networkUrl(
            Uri.parse(firstFile.xFile!.path));
      }
      throw Exception('Invalid File source in list');
    }

    if (videoSource is AdaptedFile) {
      return VideoPlayerController.networkUrl(
          Uri.parse(videoSource.xFile!.path));
    }

    if (videoSource is String) {
      if (videoSource.startsWith('http')) {
        final bool isDashboard =
            DigiaUIClient.instance.developerConfig?.environment ==
                DigiaUIEnvironment.dashboard;

        final String finalUrl;
        if (isDashboard) {
          finalUrl =
              'https://asia-east2-digia-proxy-server.cloudfunctions.net/proxy?url=$videoSource';
        } else {
          finalUrl = videoSource;
        }
        return VideoPlayerController.networkUrl(Uri.parse(finalUrl));
      }
    }
    // Additional source handling if needed
    throw Exception('Unsupported video source type');
  }

  void _pauseVideo() {
    if (_chewieController.isPlaying) {
      _chewieController.pause();
    }
  }

  void _playVideo() {
    if (!_chewieController.isPlaying) {
      _chewieController.play();
    }
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!ModalRoute.of(context)!.isCurrent) {
      _pauseVideo();
    } else {
      if (widget.autoPlay ?? true) {
        _playVideo();
      }
    }

    return Chewie(controller: _chewieController);
  }
}
