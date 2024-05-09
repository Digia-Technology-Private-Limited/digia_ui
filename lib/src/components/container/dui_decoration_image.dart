import 'package:json_annotation/json_annotation.dart';
part 'dui_decoration_image.g.dart';

@JsonSerializable()
class DUIDecorationImage {
  final String? source;
  final String? fit;
  final String? alignment;
  final double? opacity;

  DUIDecorationImage(this.source, this.fit, this.alignment, this.opacity);

  factory DUIDecorationImage.fromJson(Map<String, dynamic> json) => _$DUIDecorationImageFromJson(json);

  Map<String, dynamic> toJson() => _$DUIDecorationImageToJson(this);
}
