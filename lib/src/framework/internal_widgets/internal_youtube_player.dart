import 'package:flutter/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'
    as yt_flutter;
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt_iframe;

import '../../dui_dev_config.dart';
import '../../init/digia_ui_manager.dart';

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
  late dynamic _controller;
  bool _isIframe = false;

  @override
  void initState() {
    super.initState();
    _isIframe = DigiaUIManager().host is DashboardHost;
    _initializeController();
  }

  void _initializeController() {
    final String? videoId =
        yt_flutter.YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (_isIframe) {
      _controller = yt_iframe.YoutubePlayerController.fromVideoId(
        videoId: videoId ?? '',
        autoPlay: widget.autoPlay,
        params: yt_iframe.YoutubePlayerParams(
          mute: widget.isMuted,
          showControls: true,
          showFullscreenButton: true,
          loop: widget.loop,
        ),
      );
    } else {
      _controller = yt_flutter.YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: yt_flutter.YoutubePlayerFlags(
          autoPlay: widget.autoPlay,
          mute: widget.isMuted,
          loop: widget.loop,
        ),
      );
    }
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
      final String? videoId =
          yt_flutter.YoutubePlayer.convertUrlToId(widget.videoUrl);
      if (videoId != null) {
        if (_isIframe) {
          _controller.loadVideoById(videoId: videoId);
        } else {
          _controller.load(videoId);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isIframe) {
      return yt_iframe.YoutubePlayer(
        controller: _controller,
        aspectRatio: 16 / 9,
      );
    } else {
      return yt_flutter.YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      );
    }
  }
}
