import '../utils/json_util.dart';
import '../utils/num_util.dart';
import '../utils/types.dart';

class Props {
  JsonLike value;

  Props(this.value);

  Object? get(String? keyPath) =>
      keyPath == null ? null : value.valueFor(keyPath);

  String? getString(String keyPath) => get(keyPath) as String?;

  int? getInt(String keyPath) => NumUtil.toInt(get(keyPath));

  double? getDouble(String keyPath) => NumUtil.toDouble(get(keyPath));

  bool? getBool(String keyPath) => NumUtil.toBool(get(keyPath));

  JsonLike? getMap(String keyPath) => get(keyPath) as JsonLike?;

  List<Object?>? getList(String keyPath) => get(keyPath) as List<Object?>?;

  Props? toProps(String keyPath) {
    final result = getMap(keyPath);

    if (result == null) return null;

    return Props(result);
  }

  bool get isEmpty => value.isEmpty;

  bool get isNotEmpty => value.isNotEmpty;

  factory Props.empty() => Props({});
}
