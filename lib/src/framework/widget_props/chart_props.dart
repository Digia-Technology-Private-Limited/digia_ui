import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class ChartProps {
  final ExprOr<String>? chartType;
  final ExprOr<List>? labels;
  final ExprOr<List>? chartData;
  final JsonLike? options;

  const ChartProps({
    this.chartType,
    this.labels,
    this.chartData,
    this.options,
  });

  factory ChartProps.fromJson(JsonLike json) {
    print('📝 [ChartProps] Parsing from JSON: $json');
    
    final chartType = ExprOr.fromJson<String>(json['chartType']);
    final labels = ExprOr.fromJson<List>(json['labels']);
    final chartData = ExprOr.fromJson<List>(json['chartData']);
    final options = as$<JsonLike>(json['options']);

    print('📝 [ChartProps] chartType: $chartType (${chartType.runtimeType})');
    print('📝 [ChartProps] labels: $labels (${labels.runtimeType})');
    print('📝 [ChartProps] chartData: $chartData (${chartData.runtimeType})');
    print('📝 [ChartProps] options: $options');

    return ChartProps(
      chartType: chartType,
      labels: labels,
      chartData: chartData,
      options: options,
    );
  }
}
