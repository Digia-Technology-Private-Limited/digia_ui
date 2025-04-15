import '../models/types.dart';
import '../utils/types.dart';

class BottomNavigationBarProps {
  final ExprOr<String>? backgroundColor;
  final ExprOr<int>? animationDuration;
  final ExprOr<double>? elevation;
  final ExprOr<double>? height;
  final ExprOr<String>? surfaceTintColor;
  final ExprOr<String>? overlayColor;
  final ExprOr<String>? indicatorColor;
  final ExprOr<String>? indicatorShape;
  final ExprOr<bool>? showLabels;

  const BottomNavigationBarProps({
    this.backgroundColor,
    this.animationDuration,
    this.elevation,
    this.height,
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
      elevation: ExprOr.fromJson<double>(json['elevation']),
      height: ExprOr.fromJson<double>(json['height']),
      surfaceTintColor: ExprOr.fromJson<String>(json['surfaceTintColor']),
      overlayColor: ExprOr.fromJson<String>(json['overlayColor']),
      indicatorColor: ExprOr.fromJson<String>(json['indicatorColor']),
      indicatorShape: ExprOr.fromJson<String>(json['indicatorShape']),
      showLabels: ExprOr.fromJson<bool>(json['showLabels']),
    );
  }
}
