import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';

class PaginatedSliverListProps {
  final String? apiId;
  final Map<String, ExprOr<Object>?>? args;
  final ExprOr<List>? transformItems;
  final ExprOr<Object>? firstPageKey;
  final ExprOr<Object>? nextPageKey;
  final ExprOr<Object>? apiDataSource;
  final ExprOr<Object>? dataSource;

  PaginatedSliverListProps({
    this.apiId,
    this.args,
    this.transformItems,
    this.firstPageKey,
    this.nextPageKey,
    this.apiDataSource,
    this.dataSource,
  });

  factory PaginatedSliverListProps.fromJson(JsonLike json) {
    return PaginatedSliverListProps(
      apiId: as$<String>(json.valueFor('apiDataSource.id')),
      args: as$<JsonLike>(json.valueFor('apiDataSource.args'))
          ?.map((key, value) => MapEntry(
                key,
                ExprOr.fromJson<Object>(value),
              )),
      transformItems: ExprOr.fromJson<List>(json['newItemsTransformation']),
      firstPageKey: ExprOr.fromJson<Object>(json['firstPageKey']),
      nextPageKey: ExprOr.fromJson<Object>(json['nextPageKey']),
      apiDataSource: ExprOr.fromJson<Object>(json['apiDataSource']),
      dataSource: ExprOr.fromJson<Object>(json['dataSource']),
    );
  }
}
