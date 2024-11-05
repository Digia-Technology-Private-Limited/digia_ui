import 'package:flutter/widgets.dart';

import '../models/types.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class AnimatedSwitcherProps {
  final ExprOr<bool>? showFirstChild;
  final ExprOr<int>? animationDuration;
  final Curve? switchInCurve;
  final Curve? switchOutCurve;

  const AnimatedSwitcherProps({
    this.animationDuration,
    this.showFirstChild,
    this.switchInCurve,
    this.switchOutCurve,
  });

  factory AnimatedSwitcherProps.fromJson(JsonLike json) {
    return AnimatedSwitcherProps(
      animationDuration: ExprOr.fromJson<int>(json['animationDuration']),
      showFirstChild: ExprOr.fromJson<bool>(json['showFirstChild']),
      switchInCurve: To.curve(as$<String>(json['switchInCurve'])),
      switchOutCurve: To.curve(as$<String>(json['switchOutCurve'])),
    );
  }
}
