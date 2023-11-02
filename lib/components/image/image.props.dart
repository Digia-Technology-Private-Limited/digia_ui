import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image.props.g.dart';

@JsonSerializable()
class DUIImageProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  final DUIStyleClass? styleClass;
  final String imageSrc;
  final String? placeHolder;
  final String? errorImage;
  final double? aspectRatio;
  final String? fit;

  DUIImageProps(
      {this.styleClass,
      required this.imageSrc,
      this.placeHolder,
      this.errorImage,
      this.aspectRatio,
      this.fit});

  factory DUIImageProps.fromJson(Map<String, dynamic> json) =>
      _$DUIImagePropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIImagePropsToJson(this);
}
