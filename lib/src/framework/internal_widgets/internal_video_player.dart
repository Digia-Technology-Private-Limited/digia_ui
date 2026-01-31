import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _initializationError = false;
  String? _initializationErrorMessage;
  double _aspectRatio = 16 / 9;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    final localController = _createController(widget.videoUrl);
    _videoPlayerController = localController;

    try {
      await localController.initialize();

      if (localController != _videoPlayerController) {
        localController.dispose();
        return;
      }

      if (widget.aspectRatio != null) {
        _aspectRatio = widget.aspectRatio!;
      } else {
        _aspectRatio = localController.value.aspectRatio;
      }

      _chewieController =
          _createChewieController(autoPlay: widget.autoPlay ?? true);
      _initializationError = false;
      _initializationErrorMessage = null;

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (localController != _videoPlayerController) {
        localController.dispose();
        return;
      }

      _aspectRatio = widget.aspectRatio ?? 16 / 9;
      if (mounted) {
        setState(() {
          _initializationError = true;
          _initializationErrorMessage = e.toString();
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant InternalVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeControllers();
      _chewieController = null;
      _isInitialized = false;
      _initializationError = false;
      _initializationErrorMessage = null;
      _initializeControllers();
    } else if (oldWidget.aspectRatio != widget.aspectRatio) {
      if (widget.aspectRatio != null) {
        _aspectRatio = widget.aspectRatio!;
      } else {
        _aspectRatio = _videoPlayerController.value.aspectRatio;
      }
      final wasPlaying = _chewieController?.isPlaying ?? false;
      _chewieController?.dispose();
      _chewieController = null;
      _chewieController =
          _createChewieController(autoPlay: widget.autoPlay ?? wasPlaying);
      setState(() {});
    }
  }

  ChewieController _createChewieController({required bool autoPlay}) {
    final showControls = widget.showControls ?? true;
    final looping = widget.looping ?? false;

    return ChewieController(
      videoPlayerController: _videoPlayerController,
      allowMuting: true,
      errorBuilder: _buildErrorWidget,
      showControls: showControls,
      aspectRatio: _aspectRatio,
      allowPlaybackSpeedChanging: true,
      playbackSpeeds: [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2],
      autoPlay: autoPlay,
      looping: looping,
      hideControlsTimer: const Duration(seconds: 1),
      autoInitialize: false,
      subtitle: Subtitles([
        Subtitle(
          index: 0,
          start: Duration.zero,
          end: const Duration(seconds: 10),
          text: '',
        ),
      ]),
      subtitleBuilder: _buildSubtitle,
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
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
    );
  }

  Widget _buildSubtitle(BuildContext context, dynamic subtitle) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: subtitle is InlineSpan
          ? RichText(text: subtitle)
          : Text(
              subtitle.toString(),
              style: const TextStyle(color: Colors.black),
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
        return VideoPlayerController.networkUrl(Uri.parse(videoSource));
      }
    }
    throw Exception('Unsupported video source type');
  }

  void _pauseVideo() {
    if (_chewieController?.isPlaying ?? false) {
      _chewieController?.pause();
    }
  }

  void _playVideo() {
    if (!(_chewieController?.isPlaying ?? true)) {
      _chewieController?.play();
    }
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show error UI if initialization failed
    if (_initializationError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'Video initialization failed',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (_initializationErrorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _initializationErrorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      );
    }

    // Show loading indicator while initializing
    if (!_isInitialized || _chewieController == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!ModalRoute.of(context)!.isCurrent) {
      _pauseVideo();
    } else {
      if (widget.autoPlay ?? true) {
        _playVideo();
      }
    }
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}
