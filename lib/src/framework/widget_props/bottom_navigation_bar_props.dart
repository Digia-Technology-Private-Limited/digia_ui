import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class BottomNavigationBarProps {
  final ExprOr<String>? backgroundColor;
  final ExprOr<int>? animationDuration;
  final ExprOr<double>? height;
  final ExprOr<String>? surfaceTintColor;
  final ExprOr<String>? overlayColor;
  final ExprOr<String>? indicatorColor;
  final ExprOr<String>? indicatorShape;
  final ExprOr<bool>? showLabels;
  final List<Object?>? shadow;
  final String? borderRadius;

  const BottomNavigationBarProps({
    this.backgroundColor,
    this.animationDuration,
    this.height,
    this.borderRadius,
    this.shadow,
    this.surfaceTintColor,
    this.overlayColor,
    this.indicatorColor,
    this.indicatorShape,
    this.showLabels,
  });

  factory BottomNavigationBarProps.fromJson(JsonLike json) {
    return BottomNavigationBarProps(
      backgroundColor: ExprOr.fromJson<String>(json['backgroundColor']),
      animationDuration: ExprOr.fromJson<int>(json['animationDuration']),
      height: ExprOr.fromJson<double>(json['height']),
      surfaceTintColor: ExprOr.fromJson<String>(json['surfaceTintColor']),
      overlayColor: ExprOr.fromJson<String>(json['overlayColor']),
      indicatorColor: ExprOr.fromJson<String>(json['indicatorColor']),
      indicatorShape: ExprOr.fromJson<String>(json['indicatorShape']),
      showLabels: ExprOr.fromJson<bool>(json['showLabels']),
      borderRadius: as$<String>(json['borderRadius']),
      shadow: as$<List<Object?>?>(json['shadow']),
    );
  }
}
