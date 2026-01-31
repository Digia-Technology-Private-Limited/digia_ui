import '../../../digia_ui.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class ChartProps {
  final bool? useDataSource;
  final ExprOr<String>? chartType;
  final ExprOr<List>? labels;
  final ExprOr<List>? chartData;
  final JsonLike? options;
  final ActionFlow? onChanged;
  final ExprOr<Object>? dataSource;

  const ChartProps({
    this.useDataSource,
    this.chartType,
    this.labels,
    this.chartData,
    this.options,
    this.onChanged,
    this.dataSource,
  });

  factory ChartProps.fromJson(JsonLike json) {
    return ChartProps(
      useDataSource: as$<bool>(json[
          'useDataSource']), // Fixed: Read from '_useDataSource' instead of 'useDataSource'
      chartType: ExprOr.fromJson<String>(json['chartType']),
      labels: ExprOr.fromJson<List>(json['labels']),
      chartData: ExprOr.fromJson<List>(json['chartData']),
      options: as$<JsonLike>(json['options']),
      dataSource: ExprOr.fromJson<Object>(json['dataSource']),
      onChanged: ActionFlow.fromJson(json['onChanged']),
    );
  }
}
