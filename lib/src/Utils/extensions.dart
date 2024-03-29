import 'package:flutter/material.dart';

extension KeyPath on Map {
  dynamic valueFor({required String keyPath}) {
    final keysSplit = keyPath.split('.');
    final thisKey = keysSplit.removeAt(0);
    final thisValue = this[thisKey];
    if (keysSplit.isEmpty) {
      return thisValue;
    } else if (thisValue is Map) {
      return thisValue.valueFor(keyPath: keysSplit.join('.'));
    }
  }
}

extension ExtentUtil on String {
  double? toHeight(BuildContext context) {
    return _compute(MediaQuery.of(context).size.height, this);
  }

  double? toWidth(BuildContext context) {
    return _compute(MediaQuery.of(context).size.width, this);
  }

  double? _compute(double extent, String val) {
    final s = val.trim();
    if (s.isEmpty) return null;

    if (s.characters.last == '%') {
      final substring = s.substring(0, s.length - 1);
      final factor = double.tryParse(substring);
      if (factor == null) return null;

      return extent * (factor / 100);
    }

    return double.tryParse(s);
  }
}

extension Util on BorderRadiusGeometry {
  bool isZero() {
    return this == BorderRadius.zero;
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension GeneralUtilExtension<T> on T {
  /// Returns true if object is:
  /// - null `Object`
  bool get isNull => this == null;

  /// Returns true if object is NOT:
  /// - null `Object`
  bool get isNotNull => this != null;

  /// Returns true if object is:
  /// - null `Object`
  /// - empty `String`s
  /// - empty `Iterable` (list, set, ...)
  /// - empty `Map`
  bool get isNullOrEmpty =>
      isNull ||
      _isStringObjectEmpty ||
      _isIterableObjectEmpty ||
      _isMapObjectEmpty;

  /// Returns true if object is:
  /// - null `Object`
  /// - empty `String`
  /// - empty `Iterable` (list, map, set, ...)
  /// - false `bool`
  bool get isNullEmptyOrFalse =>
      isNull ||
      _isStringObjectEmpty ||
      _isIterableObjectEmpty ||
      _isMapObjectEmpty ||
      _isBoolObjectFalse;

  /// Returns true if object is:
  /// - null `Object`
  /// - empty `String`
  /// - empty `Iterable` (list, map, set, ...)
  /// - false `bool`
  /// - zero `num`
  bool get isNullEmptyFalseOrZero =>
      isNull ||
      _isStringObjectEmpty ||
      _isIterableObjectEmpty ||
      _isMapObjectEmpty ||
      _isBoolObjectFalse ||
      _isNumObjectZero;

  // ------- PRIVATE EXTENSION HELPERS -------
  /// **Private helper**
  ///
  /// If `String` object, return String's method `isEmpty`
  ///
  /// Otherwise return `false` to not affect logical-OR expression. As `false` denotes undefined or N/A since object is not `String`
  bool get _isStringObjectEmpty =>
      (this is String) ? (this as String).isEmpty : false;

  /// **Private helper**
  ///
  /// If `Iterable` object, return Iterable's method `isEmpty`
  ///
  /// Otherwise return `false` to not affect logical-OR expression. As `false` denotes undefined or N/A since object is not `Iterable`
  bool get _isIterableObjectEmpty =>
      (this is Iterable) ? (this as Iterable).isEmpty : false;

  /// **Private helper**
  ///
  /// If `Map` object, return Map's method `isEmpty`
  ///
  /// Otherwise return `false` to not affect logical-OR expression. As `false` denotes undefined or N/A since object is not `Map`
  bool get _isMapObjectEmpty => (this is Map) ? (this as Map).isEmpty : false;

  /// **Private helper**
  ///
  /// If `bool` object, return `isFalse` expression
  ///
  /// Otherwise return `false` to not affect logical-OR expression. As `false` denotes undefined or N/A since object is not `bool`
  bool get _isBoolObjectFalse =>
      (this is bool) ? (this as bool) == false : false;

  /// **Private helper**
  ///
  /// If `num` object, return `isZero` expression
  ///
  /// Otherwise return `false` to not affect logical-OR expression. As `false` denotes undefined or N/A since object is not `num`
  bool get _isNumObjectZero => (this is num) ? (this as num) == 0 : false;
}
