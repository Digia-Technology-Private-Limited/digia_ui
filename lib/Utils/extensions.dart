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

extension Util on BorderRadiusGeometry {
  bool isZero() {
    return this == BorderRadius.zero;
  }
}
