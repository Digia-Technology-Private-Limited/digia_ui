// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_vertical_divider_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIVerticalDividerProps _$DUIVerticalDividerPropsFromJson(
        Map<String, dynamic> json) =>
    DUIVerticalDividerProps(
      lineStyle: json['lineStyle'] as String?,
      color: json['color'] as String?,
      thickness: (json['thickness'] as num?)?.toDouble(),
      indent: (json['indent'] as num?)?.toDouble(),
      endIndent: (json['endIndent'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DUIVerticalDividerPropsToJson(
        DUIVerticalDividerProps instance) =>
    <String, dynamic>{
      'lineStyle': instance.lineStyle,
      'width': instance.width,
      'color': instance.color,
      'thickness': instance.thickness,
      'indent': instance.indent,
      'endIndent': instance.endIndent,
    };
