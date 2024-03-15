import 'package:digia_ui/src/components/dui_youtube_player/dui_youtube_player_props.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  late TextEditingController _seekToController;

  final double _volume = 100;
  bool _isPlayerReady = false;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.props.videoUrl ?? '')!,
      flags: YoutubePlayerFlags(
        mute: widget.props.isMuted ?? false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    super.initState();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
      topActions: <Widget>[
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            _controller.metadata.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
            size: 25.0,
          ),

          // setting
          onPressed: () {},
        ),
      ],
      onReady: () {
        _isPlayerReady = true;
      },
      onEnded: (data) {
        _controller.pause();
      },
    );
  }
}
