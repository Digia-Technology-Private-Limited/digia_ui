import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';

class PaginatedListViewProps {
  final ExprOr<String>? initialScrollPosition;
  final ExprOr<bool>? reverse;
  final String? apiId;
  final Map<String, ExprOr<Object>?>? args;
  final ExprOr<List>? transformItems;
  final ExprOr<Object>? firstPageKey;
  final ExprOr<Object>? nextPageKey;

  PaginatedListViewProps({
    this.initialScrollPosition,
    this.reverse,
    this.apiId,
    this.args,
    this.firstPageKey,
    this.nextPageKey,
    this.transformItems,
  });

  factory PaginatedListViewProps.fromJson(JsonLike json) {
    return PaginatedListViewProps(
      initialScrollPosition:
          ExprOr.fromJson<String>(json['initialScrollPosition']),
      reverse: ExprOr.fromJson<bool>(json['reverse']),
      apiId: as$<String>(json.valueFor('dataSource.id')),
      args: as$<JsonLike>(json.valueFor('dataSource.args'))
          ?.map((key, value) => MapEntry(
                key,
                ExprOr.fromJson<Object>(value),
              )),
      transformItems: ExprOr.fromJson<List>(json['newItemsTransformation']),
      firstPageKey: ExprOr.fromJson<Object>(json['firstPageKey']),
      nextPageKey: ExprOr.fromJson<Object>(json['nextPageKey']),
    );
  }
}
