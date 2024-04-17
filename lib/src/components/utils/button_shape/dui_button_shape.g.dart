// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_button_shape.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIButtonShape _$DUIButtonShapeFromJson(Map<String, dynamic> json) =>
    DUIButtonShape(
      borderColor: json['borderColor'] as String?,
      eccentricity: (json['eccentricity'] as num?)?.toDouble(),
      borderRadius: json['borderRadius'] == null
          ? null
          : DUICornerRadius.fromJson(json['borderRadius']),
      borderStyle: json['borderStyle'] as String?,
      borderWidth: (json['borderWidth'] as num?)?.toDouble(),
      buttonShape: json['buttonShape'] as String?,
    );

Map<String, dynamic> _$DUIButtonShapeToJson(DUIButtonShape instance) =>
    <String, dynamic>{
      'eccentricity': instance.eccentricity,
      'borderStyle': instance.borderStyle,
      'borderColor': instance.borderColor,
      'buttonShape': instance.buttonShape,
      'borderRadius': instance.borderRadius,
      'borderWidth': instance.borderWidth,
    };
