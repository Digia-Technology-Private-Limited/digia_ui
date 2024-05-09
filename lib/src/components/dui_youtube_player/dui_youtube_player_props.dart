import 'package:json_annotation/json_annotation.dart';

part 'dui_youtube_player_props.g.dart';

@JsonSerializable()
class DUIYoutubePlayerProps {
  final String? videoUrl;
  final bool? isMuted;
  final bool? autoPlay;
  final bool? loop;

  DUIYoutubePlayerProps({
    this.videoUrl,
    this.isMuted,
    this.autoPlay,
    this.loop,
  });

  factory DUIYoutubePlayerProps.fromJson(Map<String, dynamic> json) =>
      _$DUIYoutubePlayerPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIYoutubePlayerPropsToJson(this);
}
