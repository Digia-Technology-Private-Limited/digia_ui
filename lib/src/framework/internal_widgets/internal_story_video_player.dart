import 'package:flutter/cupertino.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';
import 'package:video_player/video_player.dart';

typedef OnVideoLoad = void Function(VideoPlayerController?);

class InternalStoryVideoPlayer extends StatefulWidget {
  final String videoUrl; 
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
  State<InternalStoryVideoPlayer> createState() =>
      _InternalStoryVideoPlayerState();
}

class _InternalStoryVideoPlayerState extends State<InternalStoryVideoPlayer> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(InternalStoryVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _reinitializeVideo();
    }
  }

  void _reinitializeVideo() {
    _videoController?.dispose();
    _videoController = null;
    
    if (mounted) {
      setState(() {
        _isInitialized = false;
      });
    }
    
    _notifyVideoLoading();
    _initializeVideo();
  }

  void _notifyVideoLoading() {
    /// Notify presenter that a video exists and is loading
    final callbackProvider = context.getInheritedWidgetOfExactType<StoryVideoCallbackProvider>();
    try {
      callbackProvider?.onVideoLoad?.call(null);
    } catch (_) {}
  }

  Future<void> _initializeVideo() async {
    try {
      _notifyVideoLoading();
      
      _videoController = _createController(widget.videoUrl);
      await _videoController!.initialize();

      /// Register with story presenter for multi-video management
      final callbackProvider = StoryVideoCallbackProvider.maybeOf(context);
      if (callbackProvider != null) {
        callbackProvider.onVideoLoad?.call(_videoController!);
      }

      if (widget.looping == true) {
        await _videoController!.setLooping(true);
      }

      /// Auto-play if specified (defaults to true for stories)
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
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  VideoPlayerController _createController(String videoUrl) {
    if (videoUrl.isEmpty) {
      throw Exception('Video URL cannot be empty');
    }

    if (videoUrl.startsWith('http://') || videoUrl.startsWith('https://')) {
      try {
        final uri = Uri.parse(videoUrl);
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

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _videoController == null) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    /// Ensure video is fully initialized before rendering
    if (!_videoController!.value.isInitialized) {
      return const Center(
        child: CupertinoActivityIndicator(),
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
