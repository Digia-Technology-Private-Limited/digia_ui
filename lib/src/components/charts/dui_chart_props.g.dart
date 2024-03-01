// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_chart_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIChartProps _$DUIChartPropsFromJson(Map<String, dynamic> json) =>
    DUIChartProps()
      ..styleClass = DUIStyleClass.fromJson(json['styleClass'])
      ..data = DUIChartData.fromJson(json['data'] as Map<String, dynamic>);

Map<String, dynamic> _$DUIChartPropsToJson(DUIChartProps instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

DUIChartData _$DUIChartDataFromJson(Map<String, dynamic> json) => DUIChartData()
  ..type = json['type'] as String
  ..series = (json['series'] as List<dynamic>)
      .map((e) => DUIChartSeriesData.fromJson(e as Map<String, dynamic>))
      .toList()
  ..xAxis = DUIChartAxisData.fromJson(json['xAxis'] as Map<String, dynamic>)
  ..yAxis = DUIChartAxisData.fromJson(json['yAxis'] as Map<String, dynamic>);

Map<String, dynamic> _$DUIChartDataToJson(DUIChartData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'series': instance.series,
      'xAxis': instance.xAxis,
      'yAxis': instance.yAxis,
    };

DUIChartSeriesData _$DUIChartSeriesDataFromJson(Map<String, dynamic> json) =>
    DUIChartSeriesData()
      ..group = json['group'] as String
      ..color = json['color'] as String?
      ..width = (json['width'] as num?)?.toDouble()
      ..data = (json['data'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList()
      ..lineStyle = json['lineStyle'] as Map<String, dynamic>?;

Map<String, dynamic> _$DUIChartSeriesDataToJson(DUIChartSeriesData instance) =>
    <String, dynamic>{
      'group': instance.group,
      'color': instance.color,
      'width': instance.width,
      'data': instance.data,
      'lineStyle': instance.lineStyle,
    };

DUIChartAxisData _$DUIChartAxisDataFromJson(Map<String, dynamic> json) =>
    DUIChartAxisData()
      ..name = json['name'] as String
      ..min = json['min'] as num?
      ..max = json['max'] as num?
      ..data =
          (json['data'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..labelFormatter = json['labelFormatter'] as String?;

Map<String, dynamic> _$DUIChartAxisDataToJson(DUIChartAxisData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'min': instance.min,
      'max': instance.max,
      'data': instance.data,
      'labelFormatter': instance.labelFormatter,
    };
