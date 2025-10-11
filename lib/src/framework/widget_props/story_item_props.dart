import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class StoryItemProps {
  final ExprOr<String>? url;
  final ExprOr<String>? storyItemType; // image | video
  final ExprOr<int>? durationInMs;
  final ExprOr<String>? source; // network | asset
  final ExprOr<bool>? isMuteByDefault;
  final JsonLike? videoConfig;
  final JsonLike? imageConfig;

  const StoryItemProps({
    this.url,
    this.storyItemType,
    this.durationInMs,
    this.source,
    this.isMuteByDefault,
    this.videoConfig,
    this.imageConfig,
  });

  factory StoryItemProps.fromJson(JsonLike json) {
    return StoryItemProps(
      url: ExprOr.fromJson<String>(json['url']),
      storyItemType: ExprOr.fromJson<String>(json['storyItemType']),
      durationInMs: ExprOr.fromJson<int>(json['durationInMs']),
      source: ExprOr.fromJson<String>(json['source']),
      isMuteByDefault: ExprOr.fromJson<bool>(json['isMuteByDefault']),      
      videoConfig: as$<JsonLike>(json['videoConfig']),
      imageConfig: as$<JsonLike>(json['imageConfig']),
    );
  }
}


