import '../data_type/adapted_types/scroll_controller.dart';
import '../models/types.dart';
import '../utils/types.dart';

class MasonryGridViewProps {
  final ExprOr<AdaptedScrollController>? controller;
  final ExprOr<Object>? dataSource;
  final ExprOr<bool>? allowScroll;
  final ExprOr<bool>? shrinkWrap;
  final ExprOr<int>? crossAxisCount;
  final ExprOr<double>? crossAxisSpacing;
  final ExprOr<double>? mainAxisSpacing;
  final ExprOr<int>? mainAxisCellCount;
  final ExprOr<int>? crossAxisCellCount;

  const MasonryGridViewProps({
    this.controller,
    this.dataSource,
    this.allowScroll,
    this.shrinkWrap,
    this.crossAxisCount,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.mainAxisCellCount,
    this.crossAxisCellCount,
  });

  factory MasonryGridViewProps.fromJson(JsonLike json) {
    return MasonryGridViewProps(
      controller: ExprOr.fromJson<AdaptedScrollController>(json['controller']),
      dataSource: ExprOr.fromJson<Object>(json['dataSource']),
      allowScroll: ExprOr.fromJson<bool>(json['allowScroll']),
      shrinkWrap: ExprOr.fromJson<bool>(json['shrinkWrap']),
      crossAxisCount: ExprOr.fromJson<int>(json['crossAxisCount']),
      crossAxisSpacing: ExprOr.fromJson<double>(json['crossAxisSpacing']),
      mainAxisSpacing: ExprOr.fromJson<double>(json['mainAxisSpacing']),
      mainAxisCellCount: ExprOr.fromJson<int>(json['mainAxisCellCount']),
      crossAxisCellCount: ExprOr.fromJson<int>(json['crossAxisCellCount']),
    );
  }
}
