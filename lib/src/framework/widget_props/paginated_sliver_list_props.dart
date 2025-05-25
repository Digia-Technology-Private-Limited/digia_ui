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
  final ExprOr<Object>? dataSource;

  PaginatedSliverListProps({
    this.apiId,
    this.args,
    this.transformItems,
    this.firstPageKey,
    this.nextPageKey,
    this.dataSource,
  });

  factory PaginatedSliverListProps.fromJson(JsonLike json) {
    return PaginatedSliverListProps(
      apiId: as$<String>(json.valueFor('dataSource.id')),
      args: as$<JsonLike>(json.valueFor('dataSource.args'))
          ?.map((key, value) => MapEntry(
                key,
                ExprOr.fromJson<Object>(value),
              )),
      transformItems: ExprOr.fromJson<List>(json['newItemsTransformation']),
      firstPageKey: ExprOr.fromJson<Object>(json['firstPageKey']),
      nextPageKey: ExprOr.fromJson<Object>(json['nextPageKey']),
      dataSource: ExprOr.fromJson<Object>(json['dataSource']),
    );
  }
}
