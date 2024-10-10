import 'package:digia_expr/src/types.dart';

import '../utils/types.dart';
import 'base.dart';

class JsonAdaptor extends TypeAdapter<JsonLike> {
  @override
  ExprClassInstance wrap(JsonLike value) {
    return ExprClassInstance(
      klass: ExprClass(
          name: 'JsonLike',
          fields: value.map((k, v) => MapEntry(k, v)),
          methods: {}),
    );
  }

  @override
  bool canAdapt(Object? value) => value is JsonLike;
}
