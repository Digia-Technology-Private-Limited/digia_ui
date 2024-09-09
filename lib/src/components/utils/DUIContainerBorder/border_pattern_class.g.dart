// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'border_pattern_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorderPatternClass _$BorderPatternClassFromJson(Map<String, dynamic> json) =>
    BorderPatternClass()
      ..borderPattern =
          $enumDecodeNullable(_$BorderPatternEnumMap, json['borderPattern'])
      ..strokeCap = $enumDecodeNullable(_$StrokeCapEnumMap, json['strokeCap'])
      ..dashPattern = json['dashPattern'] as String?;

Map<String, dynamic> _$BorderPatternClassToJson(BorderPatternClass instance) =>
    <String, dynamic>{
      'borderPattern': _$BorderPatternEnumMap[instance.borderPattern],
      'strokeCap': _$StrokeCapEnumMap[instance.strokeCap],
      'dashPattern': instance.dashPattern,
    };

const _$BorderPatternEnumMap = {
  BorderPattern.solid: 'solid',
  BorderPattern.dotted: 'dotted',
  BorderPattern.dashed: 'dashed',
};

const _$StrokeCapEnumMap = {
  StrokeCap.butt: 'butt',
  StrokeCap.round: 'round',
  StrokeCap.square: 'square',
};
