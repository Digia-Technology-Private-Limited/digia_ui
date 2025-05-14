import 'package:flutter/widgets.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../utils/flutter_type_converters.dart';
import '../../../utils/object_util.dart';
import '../../adapted_types/scroll_controller.dart';
import '../base.dart';

class ScrollControllerJumpToCommand
    implements MethodCommand<AdaptedScrollController> {
  @override
  void run(ScrollController instance, Map<String, Object?> args) {
    double offset = args['offset']?.to<double>() ?? 0.0;
    instance.jumpTo(offset);
  }
}

class ScrollControllerAnimateToCommand
    implements MethodCommand<AdaptedScrollController> {
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

class ScrollControllerJumpToIndex
    implements MethodCommand<AdaptedScrollController> {
  @override
  void run(AutoScrollController instance, Map<String, Object?> args) {
    int index = args['index']?.to<int>() ?? 0;
    final durationInMs = args['durationInMs']?.to<int>() ?? 300;
    final scrollPosition = switch (args['scrollPosition']?.to<String>()) {
      'begin' => AutoScrollPosition.begin,
      'middle' => AutoScrollPosition.middle,
      'end' => AutoScrollPosition.end,
      _ => null,
    };
    instance.scrollToIndex(
      index,
      duration: Duration(milliseconds: durationInMs),
      preferPosition: scrollPosition,
    );
  }
}
