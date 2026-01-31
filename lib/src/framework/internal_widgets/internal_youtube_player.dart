import 'package:flutter/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
    final String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        mute: widget.isMuted,
        loop: widget.loop,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InternalYoutubePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoUrl != oldWidget.videoUrl) {
      final String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      if (videoId != null) {
        _controller.load(videoId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
  }
}
