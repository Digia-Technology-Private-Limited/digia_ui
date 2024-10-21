import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

import '../../../framework/models/custom_flutter_types.dart';

part 'border_pattern_class.g.dart';

@JsonSerializable()
class BorderPatternClass {
  BorderPattern? borderPattern;
  StrokeCap? strokeCap;
  String? dashPattern;

  BorderPatternClass();

  factory BorderPatternClass.fromJson(Map<String, dynamic> json) =>
      _$BorderPatternClassFromJson(json);

  Map<String, dynamic> toJson() => _$BorderPatternClassToJson(this);
}
