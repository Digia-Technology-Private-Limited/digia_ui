// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_styled_vertical_divider_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIStyledVerticalDividerProps _$DUIStyledVerticalDividerPropsFromJson(
        Map<String, dynamic> json) =>
    DUIStyledVerticalDividerProps(
      thickness: (json['thickness'] as num?)?.toDouble(),
      indent: (json['indent'] as num?)?.toDouble(),
      endIndent: (json['endIndent'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      colorType: json['colorType'] as Map<String, dynamic>?,
      borderPattern: json['borderPattern'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DUIStyledVerticalDividerPropsToJson(
        DUIStyledVerticalDividerProps instance) =>
    <String, dynamic>{
      'width': instance.width,
      'thickness': instance.thickness,
      'indent': instance.indent,
      'endIndent': instance.endIndent,
      'colorType': instance.colorType,
      'borderPattern': instance.borderPattern,
    };
