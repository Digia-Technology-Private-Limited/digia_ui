import '../utils/types.dart';

class ChartProps {
  final String? chartType;
  final List<dynamic>? labels;
  final List<Map<String, dynamic>>? chartData;
  final Map<String, dynamic>? options;

  const ChartProps({
    this.chartType,
    this.labels,
    this.chartData,
    this.options,
  });

  factory ChartProps.fromJson(JsonLike json) {
    return ChartProps(
      chartType: json['chartType'] as String?,
      labels: json['labels'] as List<dynamic>?,
      chartData: (json['chartData'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      options: json['options'] as Map<String, dynamic>?,
    );
  }
}
