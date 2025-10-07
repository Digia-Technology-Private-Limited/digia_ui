import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class StoryItemProps {
  final ExprOr<String>? url;
  final ExprOr<String>? storyItemType; // image | video
  final ExprOr<int>? durationMs;
  final ExprOr<String>? source; // network | asset
  final ExprOr<bool>? isMuteByDefault;
  final JsonLike? videoConfig;
  final JsonLike? imageConfig;

  const StoryItemProps({
    this.url,
    this.storyItemType,
    this.durationMs,
    this.source,
    this.isMuteByDefault,
    this.videoConfig,
    this.imageConfig,
  });

  factory StoryItemProps.fromJson(JsonLike json) {
    return StoryItemProps(
      url: ExprOr.fromJson<String>(json['url']),
      storyItemType: ExprOr.fromJson<String>(json['storyItemType']),
      durationMs: ExprOr.fromJson<int>(json['durationMs']),
      source: ExprOr.fromJson<String>(json['source']),
      isMuteByDefault: ExprOr.fromJson<bool>(json['isMuteByDefault']),      
      videoConfig: as$<JsonLike>(json['videoConfig']),
      imageConfig: as$<JsonLike>(json['imageConfig']),
    );
  }
}


