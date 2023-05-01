import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'image.props.g.dart';

@JsonSerializable()
class DUIImageProps {
  late double height;
  late double width;
  late String imageSrc;

  DUIImageProps();

  factory DUIImageProps.fromJson(Map<String, dynamic> json) =>
      _$DUIImagePropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIImagePropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
