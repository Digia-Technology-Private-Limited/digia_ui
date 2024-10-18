import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class IconProps {
  final JsonLike iconData;
  final ExprOr<double>? size;
  final ExprOr<String>? color;

  factory IconProps.empty() => const IconProps(iconData: {});

  const IconProps({
    required this.iconData,
    this.size,
    this.color,
  });

  static IconProps? fromJson(JsonLike? json) {
    if (json == null) return null;

    final iconData = as$<JsonLike>(json['iconData']);
    if (iconData == null) return null;

    return IconProps(
      iconData: iconData,
      size: ExprOr.fromJson<double>(json['iconSize']),
      color: ExprOr.fromJson<String>(json['iconColor']),
    );
  }

  IconProps copyWith({
    JsonLike? iconData,
    ExprOr<double>? size,
    ExprOr<String>? color,
  }) {
    return IconProps(
      iconData: iconData ?? this.iconData,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }
}
