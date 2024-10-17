import 'package:flutter/widgets.dart';

import '../../utils/flutter_type_converters.dart';
import '../../utils/object_util.dart';
import '../base.dart';

class ScrollControllerJumpToCommand implements MethodCommand<ScrollController> {
  @override
  void run(ScrollController instance, Map<String, Object?> args) {
    double offset = args['offset']?.to<double>() ?? 0.0;
    instance.jumpTo(offset);
  }
}

class ScrollControllerAnimateToCommand
    implements MethodCommand<ScrollController> {
  @override
  void run(ScrollController instance, Map<String, Object?> args) {
    double offset = args['offset']?.to<double>() ?? 0.0;
    final durationInMs = args['durationInMs']?.to<int>() ?? 300;
    final curve = To.curve(args['curve']) ?? Curves.easeIn;

    instance.animateTo(
      offset,
      duration: Duration(milliseconds: durationInMs),
      curve: curve,
    );
  }
}
