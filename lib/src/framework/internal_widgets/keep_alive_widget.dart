import 'package:flutter/widgets.dart';

class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper(
      {super.key, required this.child, this.keepTabsAlive = false});
  final Widget child;
  final bool? keepTabsAlive;

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.keepTabsAlive ?? false;

  // Subclasses must call super.build.
  // https://api.flutter.dev/flutter/widgets/AutomaticKeepAliveClientMixin-mixin.html
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
