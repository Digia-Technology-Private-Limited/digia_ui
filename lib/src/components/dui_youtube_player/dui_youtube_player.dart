import 'package:digia_ui/src/components/dui_youtube_player/dui_youtube_player_props.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/material.dart';

class DUIYoutubePlayer extends StatefulWidget {
  final DUIYoutubePlayerProps props;

  const DUIYoutubePlayer({
    super.key,
    required this.props,
  });

  @override
  State<DUIYoutubePlayer> createState() => _DUIYoutubePlayerState();
}

class _DUIYoutubePlayerState extends State<DUIYoutubePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      params: YoutubePlayerParams(
        mute: widget.props.isMuted ?? false,
        showFullscreenButton: false,
        loop: widget.props.loop ?? false,
      ),
    );


    (widget.props.autoPlay ?? false)
        ? _controller.loadVideoById(
            videoId: getVideoId(widget.props.videoUrl ?? ''),
          )
        : _controller.cueVideoById(
            videoId: getVideoId(widget.props.videoUrl ?? ''),
          );


    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    widget.props.videoUrl!.contains('https:')
        ? await _controller.loadVideo(widget.props.videoUrl ?? '')
        : await _controller.loadVideoById(videoId: widget.props.videoUrl ?? '');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
        enableFullScreenOnVerticalDrag: false,
        builder: (context, player) {
          return player;
        },
        controller: _controller);
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
