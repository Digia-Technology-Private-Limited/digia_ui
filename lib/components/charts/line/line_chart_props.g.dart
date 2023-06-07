// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_chart_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LineChartProps _$LineChartPropsFromJson(Map<String, dynamic> json) =>
    LineChartProps()
      ..styleClass = DUIStyleClass.fromJson(json['styleClass'])
      ..data = LineChartData.fromJson(json['data'] as Map<String, dynamic>);

Map<String, dynamic> _$LineChartPropsToJson(LineChartProps instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

LineChartData _$LineChartDataFromJson(Map<String, dynamic> json) =>
    LineChartData()
      ..series = (json['series'] as List<dynamic>)
          .map((e) => LineChartBarData.fromJson(e as Map<String, dynamic>))
          .toList()
      ..xAxis =
          LineChartAxisData.fromJson(json['xAxis'] as Map<String, dynamic>)
      ..yAxis =
          LineChartAxisData.fromJson(json['yAxis'] as Map<String, dynamic>);

Map<String, dynamic> _$LineChartDataToJson(LineChartData instance) =>
    <String, dynamic>{
      'series': instance.series,
      'xAxis': instance.xAxis,
      'yAxis': instance.yAxis,
    };

LineChartBarData _$LineChartBarDataFromJson(Map<String, dynamic> json) =>
    LineChartBarData()
      ..group = json['group'] as String
      ..color = json['color'] as String?
      ..width = (json['width'] as num?)?.toDouble()
      ..data = (json['data'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList()
      ..lineStyle = json['lineStyle'] as Map<String, dynamic>?;

Map<String, dynamic> _$LineChartBarDataToJson(LineChartBarData instance) =>
    <String, dynamic>{
      'group': instance.group,
      'color': instance.color,
      'width': instance.width,
      'data': instance.data,
      'lineStyle': instance.lineStyle,
    };

LineChartAxisData _$LineChartAxisDataFromJson(Map<String, dynamic> json) =>
    LineChartAxisData()
      ..name = json['name'] as String
      ..min = json['min'] as num?
      ..max = json['max'] as num?
      ..data =
          (json['data'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..labelFormatter = json['labelFormatter'] as String?;

Map<String, dynamic> _$LineChartAxisDataToJson(LineChartAxisData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'min': instance.min,
      'max': instance.max,
      'data': instance.data,
      'labelFormatter': instance.labelFormatter,
    };
