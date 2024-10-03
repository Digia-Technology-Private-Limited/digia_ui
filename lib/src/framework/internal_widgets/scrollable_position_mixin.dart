import 'package:flutter/widgets.dart';

mixin ScrollablePositionMixin<T extends StatefulWidget> on State<T> {
  setInitialScrollPosition(
    ScrollController? controller,
    String? initialScrollPosition,
  ) {
    if (controller == null) return;

    if (initialScrollPosition == 'end') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToEnd(controller);
      });
    }
  }

  void _scrollToEnd(ScrollController controller) {
    if (!mounted) return;
    if (controller.hasClients == true) {
      controller.jumpTo(controller.position.maxScrollExtent);
    }
  }
}
