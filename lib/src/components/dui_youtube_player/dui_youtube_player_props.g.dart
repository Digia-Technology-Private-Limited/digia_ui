// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_youtube_player_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIYoutubePlayerProps _$DUIYoutubePlayerPropsFromJson(
        Map<String, dynamic> json) =>
    DUIYoutubePlayerProps(
      videoUrl: json['videoUrl'] as String?,
      isMuted: json['isMuted'] as bool?,
      autoPlay: json['autoPlay'] as bool?,
      loop: json['loop'] as bool?,
    );

Map<String, dynamic> _$DUIYoutubePlayerPropsToJson(
        DUIYoutubePlayerProps instance) =>
    <String, dynamic>{
      'videoUrl': instance.videoUrl,
      'isMuted': instance.isMuted,
      'autoPlay': instance.autoPlay,
      'loop': instance.loop,
    };
