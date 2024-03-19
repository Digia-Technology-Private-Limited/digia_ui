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
        showFullscreenButton: true,
        loop: true,
      ),
    );
    widget.props.videoUrl!.contains('https:')
        ? _controller.loadVideo(widget.props.videoUrl ?? '')
        : _controller.loadVideoById(videoId: widget.props.videoUrl ?? '');

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
      aspectRatio: MediaQuery.sizeOf(context).height/MediaQuery.sizeOf(context).width,
        builder: (context, player) {

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                player,
              ],
            ),
          );
        }, controller: _controller);
  }
}
