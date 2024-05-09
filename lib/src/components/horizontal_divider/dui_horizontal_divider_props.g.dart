// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_horizontal_divider_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIHorizonatalDividerProps _$DUIHorizonatalDividerPropsFromJson(Map<String, dynamic> json) =>
    DUIHorizonatalDividerProps(
      lineStyle: json['lineStyle'] as String?,
      color: json['color'] as String?,
      thickness: (json['thickness'] as num?)?.toDouble(),
      indent: (json['indent'] as num?)?.toDouble(),
      endIndent: (json['endIndent'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DUIHorizonatalDividerPropsToJson(DUIHorizonatalDividerProps instance) => <String, dynamic>{
      'lineStyle': instance.lineStyle,
      'height': instance.height,
      'color': instance.color,
      'thickness': instance.thickness,
      'indent': instance.indent,
      'endIndent': instance.endIndent,
    };
