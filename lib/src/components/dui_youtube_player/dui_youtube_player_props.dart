import 'package:json_annotation/json_annotation.dart';

part 'dui_youtube_player_props.g.dart';

@JsonSerializable()
class DUIYoutubePlayerProps {
  final String? videoUrl;
  final bool? isMuted;

  DUIYoutubePlayerProps({
    this.videoUrl,
    this.isMuted,
  });

  factory DUIYoutubePlayerProps.fromJson(Map<String, dynamic> json) =>
      _$DUIYoutubePlayerPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIYoutubePlayerPropsToJson(this);
}
