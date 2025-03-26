import 'package:flutter/widgets.dart';

import '../../../../../digia_ui.dart';
import '../../../utils/object_util.dart';
import '../../adapted_types/page_controller.dart';
import '../base.dart';

class PageControllerJumpToPageCommand
    implements MethodCommand<AdaptedPageController> {
  @override
  void run(PageController instance, Map<String, Object?> args) {
    int page = args['page']?.to<int>() ?? 0;
    instance.jumpToPage(page);
  }
}

class PageControllerAnimateToPageCommand
    implements MethodCommand<AdaptedPageController> {
  @override
  void run(PageController instance, Map<String, Object?> args) {
    int page = args['page']?.to<int>() ?? 0;
    final durationInMs = args['durationInMs']?.to<int>() ?? 300;
    final curve = To.curve(args['curve']) ?? Curves.easeIn;
    instance.animateToPage(page,
        duration: Duration(milliseconds: durationInMs), curve: curve);
  }
}

class PageControllerNextPageCommand
    implements MethodCommand<AdaptedPageController> {
  @override
  void run(PageController instance, Map<String, Object?> args) {
    final durationInMs = args['durationInMs']?.to<int>() ?? 300;
    final curve = To.curve(args['curve']) ?? Curves.easeIn;
    instance.nextPage(
        duration: Duration(milliseconds: durationInMs), curve: curve);
  }
}

class PageControllerPreviousPageCommand
    implements MethodCommand<AdaptedPageController> {
  @override
  void run(PageController instance, Map<String, Object?> args) {
    final durationInMs = args['durationInMs']?.to<int>() ?? 300;
    final curve = To.curve(args['curve']) ?? Curves.easeIn;
    instance.previousPage(
        duration: Duration(milliseconds: durationInMs), curve: curve);
  }
}
