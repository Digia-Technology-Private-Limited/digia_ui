import 'package:flutter/material.dart';

import '../../components/dui_youtube_player/dui_youtube_player.dart';
import '../../components/dui_youtube_player/dui_youtube_player_props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIYoutubePlayerBuilder extends DUIWidgetBuilder {
  DUIYoutubePlayerBuilder({required super.data});

  static DUIYoutubePlayerBuilder create(DUIWidgetJsonData data) {
    return DUIYoutubePlayerBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIYoutubePlayer(
      props: DUIYoutubePlayerProps.fromJson(data.props),
    );
  }
}
