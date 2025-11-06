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
    return ChartProps(
      chartType: ExprOr.fromJson<String>(json['chartType']),
      labels: ExprOr.fromJson<List>(json['labels']),
      chartData: ExprOr.fromJson<List>(json['chartData']),
      options: as$<JsonLike>(json['options']),
    );
  }
}
