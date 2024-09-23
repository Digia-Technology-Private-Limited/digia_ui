// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_styled_horizontal_divider_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIStyledHorizonatalDividerProps _$DUIStyledHorizonatalDividerPropsFromJson(
        Map<String, dynamic> json) =>
    DUIStyledHorizonatalDividerProps(
      thickness: (json['thickness'] as num?)?.toDouble(),
      indent: (json['indent'] as num?)?.toDouble(),
      endIndent: (json['endIndent'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      colorType: json['colorType'] as Map<String, dynamic>?,
      borderPattern: json['borderPattern'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DUIStyledHorizonatalDividerPropsToJson(
        DUIStyledHorizonatalDividerProps instance) =>
    <String, dynamic>{
      'height': instance.height,
      'thickness': instance.thickness,
      'indent': instance.indent,
      'endIndent': instance.endIndent,
      'colorType': instance.colorType,
      'borderPattern': instance.borderPattern,
    };
