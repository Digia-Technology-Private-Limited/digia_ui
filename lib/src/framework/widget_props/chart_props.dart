import '../../../digia_ui.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class ChartProps {
  final ExprOr<String>? chartType;
  final ExprOr<List>? labels;
  final ExprOr<List>? chartData;
  final JsonLike? options;
  final ActionFlow? onChanged;
  final ExprOr<Object>? dataSource;
  final bool useDataSource;

  const ChartProps(
    this.useDataSource, {
    this.chartType,
    this.labels,
    this.chartData,
    this.options,
    this.onChanged,
    this.dataSource,
  });

  factory ChartProps.fromJson(JsonLike json) {
    final chartType = ExprOr.fromJson<String>(json['chartType']);
    final labels = ExprOr.fromJson<List>(json['labels']);
    final chartData = ExprOr.fromJson<List>(json['chartData']);
    final options = as$<JsonLike>(json['options']);
    final dataSource = ExprOr.fromJson<Object>(json['dataSource']);
    final onChanged = ActionFlow.fromJson(json['onChanged']);
    final useDataSource = dataSource != null;

    return ChartProps(
      useDataSource,
      chartType: chartType,
      labels: labels,
      chartData: chartData,
      options: options,
      dataSource: dataSource,
      onChanged: onChanged,
    );
  }
}
