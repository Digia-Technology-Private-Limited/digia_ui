import 'package:flutter/widgets.dart';

extension EdgeInsetsGeometryExtension on EdgeInsetsGeometry {
  bool get isZero => this == EdgeInsets.zero;
}

extension BorderRadiusGeometryExtension on BorderRadiusGeometry {
  bool get isZero => this == BorderRadius.zero;
}

extension ExtentUtil on String {
  /// Converts the string to a height value based on the screen height.
  ///
  /// Returns null if the string is invalid or empty.
  double? toHeight(BuildContext context) {
    return _computeExtent(MediaQuery.of(context).size.height);
  }

  /// Converts the string to a width value based on the screen width.
  ///
  /// Returns null if the string is invalid or empty.
  double? toWidth(BuildContext context) {
    return _computeExtent(MediaQuery.of(context).size.width);
  }

  /// Computes the actual extent based on the given total extent and the string value.
  ///
  /// Supports percentage (e.g., "50%") and absolute (e.g., "100.5") values.
  /// Returns null for invalid input.
  double? _computeExtent(double totalExtent) {
    final trimmedValue = trim();
    if (trimmedValue.isEmpty) return null;

    if (trimmedValue.endsWith('%')) {
      return _handlePercentage(totalExtent, trimmedValue);
    }

    return double.tryParse(trimmedValue);
  }

  /// Handles percentage values, converting them to actual extent.
  ///
  /// Returns null if the percentage value is invalid.
  double? _handlePercentage(double totalExtent, String percentageValue) {
    final percentageString =
        percentageValue.substring(0, percentageValue.length - 1);
    final percentage = double.tryParse(percentageString);
    if (percentage == null) return null;

    return totalExtent * (percentage / 100);
  }
}
