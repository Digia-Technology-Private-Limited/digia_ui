// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EEChartProps _$EEChartPropsFromJson(Map<String, dynamic> json) => EEChartProps()
  ..heading = DUITextProps.fromJson(json['heading'])
  ..mainText = DUITextProps.fromJson(json['mainText'])
  ..comparisonText = DUITextProps.fromJson(json['comparisonText'])
  ..chartData =
      DUIChartProps.fromJson(json['chartData'] as Map<String, dynamic>)
  ..bottomText = DUITextProps.fromJson(json['bottomText']);

Map<String, dynamic> _$EEChartPropsToJson(EEChartProps instance) =>
    <String, dynamic>{
      'heading': instance.heading,
      'mainText': instance.mainText,
      'comparisonText': instance.comparisonText,
      'chartData': instance.chartData,
      'bottomText': instance.bottomText,
    };
