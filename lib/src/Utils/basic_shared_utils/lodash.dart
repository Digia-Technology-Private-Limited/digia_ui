import 'package:digia_ui/src/Utils/extensions.dart';

Map<String, T> keyBy<T>(
  Iterable<T> list,
  String Function(T) keySelector,
) {
  return list.keyBy(keySelector);
}

extension LodashSetValue on Map<String, dynamic> {
  void _setValue(
      Map<String, dynamic> object, List<String> path, dynamic value) {
    final lastKey = path.removeLast();
    Map<String, dynamic> current = object;

    for (final key in path) {
      if (!current.containsKey(key) || current[key] is! Map<String, dynamic>) {
        current[key] = <String, dynamic>{};
      }
      current = current[key] as Map<String, dynamic>;
    }

    current[lastKey] = value;
  }

  void set(String path, dynamic value) {
    final pathParts = path.split('.');
    _setValue(this, pathParts, value);
  }
}

extension Lodash<T> on Iterable<T> {
  Map<String, T> keyBy(String Function(T) keySelector) {
    return fold({}, (result, element) {
      result[keySelector(element)] = element;
      return result;
    });
  }
}

// https://stackoverflow.com/a/66294173
extension MoveElement<T> on List<T> {
  void move(int from, int to) {
    RangeError.checkValidIndex(from, this, 'from', length);
    RangeError.checkValidIndex(to, this, 'to', length);
    var element = this[from];
    if (from < to) {
      setRange(from, to, this, from + 1);
    } else {
      setRange(to + 1, from + 1, this, to);
    }
    this[to] = element;
  }

  void moveElement(T element, int offset) {
    var from = indexOf(element);
    if (from < 0) return; // Or throw, whatever you want.
    var to = from + offset;
    // Check to position is valid. Or cap it at 0/length - 1.
    RangeError.checkValidIndex(to, this, 'target position', length);
    element = this[from];
    if (from < to) {
      setRange(from, to, this, from + 1);
    } else {
      setRange(to + 1, from + 1, this, to);
    }
    this[to] = element;
  }
}

T? castOrNull<T>(dynamic x) {
  try {
    return cast<T>(x);
  } catch (_) {
    // ignore: avoid_print
    print('CastError when trying to cast $x to $T!');
    return null;
  }
}

T castOrDefault<T>(dynamic x, {required T defaultValue}) {
  try {
    return cast<T>(x);
  } on Error catch (_) {
    // ignore: avoid_print
    print('CastError when trying to cast $x to $T!');
    return defaultValue;
  }
}

T cast<T>(dynamic x) => x as T;

R? ifNotNull<R, T>(T? arg, R? Function(T) f) => (arg == null) ? null : f(arg);

R? ifNotNull2<R, T0, T1>(T0? arg0, T1? arg1, R? Function(T0, T1) f) =>
    (arg0 != null && arg1 != null) ? f(arg0, arg1) : null;

// R? ifTruthy<R, T>(T? arg, R? Function(T) f) =>
//     // ignore: null_check_on_nullable_type_parameter
//     arg.isNullEmptyFalseOrZero ? null : f(arg!);

extension Let<T> on T? {
  R? let<R>(R? Function(T) f) {
    if (this == null) return null;

    return f(this as T);
  }

  R? letIf<R>(bool Function(T) predicate, R? Function(T) block) {
    return this.let((p0) => predicate(p0) ? block(this as T) : null);
  }

  R? letIfTrue<R>(R? Function(T) block) {
    return this.letIf((p0) => !p0.isNullEmptyFalseOrZero, block);
  }
}

extension Let2<T, R> on (T?, R?) {
  S? let<S>(S Function(T, R) block) {
    return (this.$1 != null && this.$2 != null)
        ? block(this.$1 as T, this.$2 as R)
        : null;
  }
}
