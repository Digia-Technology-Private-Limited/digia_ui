import 'package:flutter/widgets.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class InternalYoutubePlayer extends StatefulWidget {
  final String videoUrl;
  final bool isMuted;
  final bool loop;
  final bool autoPlay;

  const InternalYoutubePlayer({
    super.key,
    required this.videoUrl,
    this.isMuted = false,
    this.loop = false,
    this.autoPlay = false,
  });

  @override
  State<InternalYoutubePlayer> createState() => _InternalYoutubePlayerState();
}

class _InternalYoutubePlayerState extends State<InternalYoutubePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = YoutubePlayerController(
      params: YoutubePlayerParams(
        mute: widget.isMuted,
        showFullscreenButton: false,
        loop: widget.loop,
      ),
    );

    widget.autoPlay
        ? _controller.loadVideoById(videoId: getVideoId(widget.videoUrl))
        : _controller.cueVideoById(videoId: getVideoId(widget.videoUrl));
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InternalYoutubePlayer oldWidget) {
    if (widget.videoUrl != oldWidget.videoUrl) {
      _controller.cueVideoById(videoId: getVideoId(widget.videoUrl));
    }
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      enableFullScreenOnVerticalDrag: false,
      builder: (context, player) {
        return player;
      },
      controller: _controller,
    );
  }

  String getVideoId(String url) {
    if (url.contains('https:')) {
      final params = Uri.parse(url).queryParameters;
      final videoId = params['v'];
      return videoId ?? '';
    } else {
      return url;
    }
  }
}
