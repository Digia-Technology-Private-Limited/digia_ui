import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class NavigationBarCustomProps {
  final ExprOr<String>? backgroundColor;
  final ExprOr<int>? animationDuration;
  final ExprOr<double>? height;
  final ExprOr<String>? surfaceTintColor;
  final ExprOr<String>? overlayColor;
  final ExprOr<String>? indicatorColor;
  final ExprOr<String>? indicatorShape;
  final ExprOr<bool>? preservePage;
  final List<Object?>? shadow;
  final String? borderRadius;

  const NavigationBarCustomProps({
    this.backgroundColor,
    this.animationDuration,
    this.height,
    this.borderRadius,
    this.shadow,
    this.surfaceTintColor,
    this.overlayColor,
    this.indicatorColor,
    this.indicatorShape,
    this.preservePage,
  });

  factory NavigationBarCustomProps.fromJson(JsonLike json) {
    return NavigationBarCustomProps(
      backgroundColor: ExprOr.fromJson<String>(json['backgroundColor']),
      animationDuration: ExprOr.fromJson<int>(json['animationDuration']),
      height: ExprOr.fromJson<double>(json['height']),
      surfaceTintColor: ExprOr.fromJson<String>(json['surfaceTintColor']),
      overlayColor: ExprOr.fromJson<String>(json['overlayColor']),
      indicatorColor: ExprOr.fromJson<String>(json['indicatorColor']),
      indicatorShape: ExprOr.fromJson<String>(json['indicatorShape']),
      preservePage: ExprOr.fromJson<bool>(json['preservePage']),
      borderRadius: as$<String>(json['borderRadius']),
      shadow: as$<List<Object?>?>(json['shadow']),
    );
  }
}
