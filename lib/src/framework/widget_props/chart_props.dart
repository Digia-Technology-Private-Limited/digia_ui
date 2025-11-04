import '../utils/types.dart';

class ChartProps {
  final List<Map<String, dynamic>>? chartData;

  const ChartProps({this.chartData});

  factory ChartProps.fromJson(JsonLike json) {
    return ChartProps(
      chartData: (json['chartData'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }
}