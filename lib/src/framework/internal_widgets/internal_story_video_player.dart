import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import 'package:video_player/video_player.dart';

import '../data_type/adapted_types/file.dart';

// Import the callback provider from the SDK
// Note: This is a private class from the SDK, we'll need to make it public or use a different approach
typedef OnVideoLoad = void Function(VideoPlayerController?);

class InternalStoryVideoPlayer extends StatefulWidget {
  final Object videoUrl;
  final bool? autoPlay;
  final bool? looping;
  final BoxFit? fit;

  const InternalStoryVideoPlayer({
    super.key,
    required this.videoUrl,
    this.autoPlay,
    this.looping,
    this.fit,
  });

  @override
  State<InternalStoryVideoPlayer> createState() => _InternalStoryVideoPlayerState();
}

class _InternalStoryVideoPlayerState extends State<InternalStoryVideoPlayer> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = _createController(widget.videoUrl);
      await _videoController!.initialize();
      
      // Register with story presenter if available
      final callbackProvider = StoryVideoCallbackProvider.maybeOf(context);
      callbackProvider?.onVideoLoad?.call(_videoController!);
      
      // Set looping if specified
      if (widget.looping == true) {
        await _videoController!.setLooping(true);
      }
      
      // Auto-play if specified (default true for stories)
      if (widget.autoPlay ?? true) {
        await _videoController!.play();
      }
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      // Don't call callback on error
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
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
      // Validate URL before creating controller
      if (videoSource.isEmpty) {
        throw Exception('Video URL cannot be empty');
      }
      
      if (videoSource.startsWith('http://') || videoSource.startsWith('https://')) {
        try {
          final uri = Uri.parse(videoSource);
          if (uri.hasScheme && uri.hasAuthority) {
            return VideoPlayerController.networkUrl(uri);
          } else {
            throw Exception('Invalid URL format');
          }
        } catch (e) {
          throw Exception('Invalid URL: $e');
        }
      } else {
        throw Exception('URL must start with http:// or https://');
      }
    }
    
    throw Exception('Unsupported video source type: ${videoSource.runtimeType}');
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _videoController == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return FittedBox(
      fit: widget.fit ?? BoxFit.cover,
      child: SizedBox(
        width: _videoController!.value.size.width,
        height: _videoController!.value.size.height,
        child: VideoPlayer(_videoController!),
      ),
    );
  }
}
